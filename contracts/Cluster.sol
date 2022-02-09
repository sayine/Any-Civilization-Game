// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import '@openzeppelin/contracts/access/Ownable.sol';

contract Cluster is ERC721, Ownable {

    mapping(uint => uint[]) citizensOfCluster;
    mapping(uint => uint) citizenToCluster;
    mapping(uint => bool) citizenAdded;
    mapping(uint => uint) citizenAddedTime;

    address private _owner;
    address private acm;
    address private _anyToken;
    address private _ctzn;
    address private _clstrhlpr;
    uint public _clusterPrice;
    
    struct Clusters {
        uint id;
        uint population;
    }
    Clusters[] public clusters;
    
    constructor() ERC721("ANY Cluster", "Cluster") {
        _owner = msg.sender;
    }
    
    function clusterPrice() external payable returns(uint) {
        if(clusters.length <= 1000){_clusterPrice = 1 ether;}
        else if(clusters.length < 2000){_clusterPrice = 1.5 ether;}
        else if(clusters.length < 3000){_clusterPrice = 2 ether;}
        else if(clusters.length < 4000){_clusterPrice = 2.5 ether;}
        else if(clusters.length < 5000){_clusterPrice = 3 ether;}
        else if(clusters.length < 6000){_clusterPrice = 3.5 ether;}
        else if(clusters.length < 7000){_clusterPrice = 4 ether;}
        else if(clusters.length < 8000){_clusterPrice = 4.5 ether;}
        else if(clusters.length < 9000){_clusterPrice = 5 ether;}
        else if(clusters.length < 10000){_clusterPrice = 5.5 ether;}
        return _clusterPrice;
    }

    function generateCluster(address _to, uint _idCitizen) onlyACM payable external returns (uint){
        uint _id = clusters.length;
        citizensOfCluster[_id].push(_idCitizen);
        citizenAdded[_idCitizen] = true;
        citizenAddedTime[_idCitizen] = block.timestamp;
        citizenToCluster[_idCitizen] = _id;
        clusters.push(Clusters(_id, 0));
        _safeMint(_to,_id);
        return _id;
    }

    function addCitizen(uint _idCitizen, uint _idCluster) onlyCitizenOwner(_idCitizen) public {
        require(_idCluster < clusters.length, "Cluster does not exist!");
        require(citizenAdded[_idCitizen] == false, "Citizen has already joined a Cluster!");
        citizensOfCluster[_idCluster].push(_idCitizen);
        clusters[_idCluster].population += 1;
        citizenAdded[_idCitizen] = true;
        citizenAddedTime[_idCitizen] = block.timestamp;
        citizenToCluster[_idCitizen] = _idCluster;
    }

    function getCitizensOfCluster(uint _idCluster, uint _idCitizen) external view returns(uint) {
        return citizensOfCluster[_idCluster][_idCitizen];
    }
    function clusterPopulation(uint _idCluster) external view returns(uint) {
        return clusters[_idCluster].population;
    }
    
    function daysOfCitizen(uint _idCitizen) public view returns (uint) {
        uint secondsOfCitizen = block.timestamp - citizenAddedTime[_idCitizen];
        uint daysOfCtzn = secondsOfCitizen / 86400;
        return daysOfCtzn;
    }

    function citizenRatio(uint _idCitizen) internal view returns (uint) {
        uint CSkill; uint MSkill; uint SSkill; uint ratio;
        (,,CSkill,) = ICitizen(_ctzn).getCitizenSkills(_idCitizen);
        (,MSkill,,) = ICitizen(_ctzn).getCitizenSkills(_idCitizen);
        (SSkill,,,) = ICitizen(_ctzn).getCitizenSkills(_idCitizen);

        if(CSkill == MSkill && MSkill == SSkill){return ratio = 10;}
        else if(CSkill == MSkill || MSkill == SSkill){return ratio = 9;}
        else {return ratio = 8;}
    }

    function citizenAnyTokenAllowance(uint _idCitizen) public returns (uint) {
        uint citizenAllowance = 5 * IClusterHelper(_clstrhlpr).ProductivityOfCluster(citizenToCluster[_idCitizen]) * daysOfCitizen(_idCitizen) * citizenRatio(_idCitizen);
        return citizenAllowance;
    }
    function clusterOwnerAnyTokenAllowance(uint _idCluster) public returns (uint) {
        uint aggCitizenAllowance;
        for(uint i = 0; i < citizensOfCluster[_idCluster].length; i++){
            aggCitizenAllowance += citizenAnyTokenAllowance(citizensOfCluster[_idCluster][i]) / citizenRatio(i);
        }
        uint clusterOwnerAllowance = aggCitizenAllowance * 10;
        return clusterOwnerAllowance;
    }

    function citizenAnyTokenMint(uint _idCluster) public onlyCitizenOwner(_idCluster) returns (bool) {
        uint allowance = clusterOwnerAnyTokenAllowance(_idCluster);
        IAnyGameToken(_anyToken).mint(ownerOf(_idCluster), allowance);
        return true;
    }
    function clusterAnyTokenMint(uint _idCitizen) public onlyCitizenOwner(_idCitizen) returns (bool) {
        uint allowance = citizenAnyTokenAllowance(_idCitizen);
        IAnyGameToken(_anyToken).mint(ICitizen(_ctzn)._ownerOf(_idCitizen), allowance);
        return true;
    }

    function setAddresses(address _acm, address anyToken, address AnyCitizen, address ClusterHelper) onlyOwner public {
        acm = _acm;
        _anyToken = anyToken;
        _ctzn = AnyCitizen;
        _clstrhlpr = ClusterHelper;
    }
    
    modifier onlyACM() {
        require(msg.sender == acm);
        _;
    }
    modifier onlyCitizenOwner(uint _idCitizen) {
        require(ICitizen(_ctzn)._ownerOf(_idCitizen) == msg.sender, "You don't own me. I'm not just one of your many toys.");
        _;
    }
    modifier onlyClusterOwner(uint _idCluster) {
        require(ownerOf(_idCluster) == msg.sender, "You don't own me. I'm not just one of your many toys.");
        _;
    }
}
    interface ICitizen {
        function _ownerOf(uint256 tokenId) external view returns (address);
        function getCitizenSkills(uint _id) external view returns(uint sSkill, uint mSkill, uint cSkill, uint aggSkill);
    }
    interface IAnyGameToken {
        function mint(address account, uint256 amount) external returns(bool);
        function burn(address account, uint256 amount) external returns(bool);
        function balances(address _address) external view returns (uint);
    }
    interface IClusterHelper {
        function ProductivityOfCluster(uint _idCluster) external returns(uint);
    }