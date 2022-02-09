// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import '@openzeppelin/contracts/access/Ownable.sol';

contract Citizen is ERC721, Ownable {

    address private _owner;
    address private acm;
    address private cluster;
    address private electricity;
    address private food;
    address private water;
    address private ore;
    uint needsFulfillTimer = 3 days;

    struct Citizens {
        uint id;
        uint startTime;
        uint ss;
        uint ms;
        uint cs;
        uint needsFulfillTime;
        bool ef;
        bool ff;
        bool wf; 
        bool mf;
        bool needsFulfilled;
    }
    
    Citizens[] public citizens;
    
    constructor() ERC721("ANY Citizen", "Citizen") {
        _owner = msg.sender;
    }
    
    function unfrozeCitizen(address  _to) onlyACM payable external returns (uint){
        uint id = citizens.length;
        citizens.push(Citizens(id, 0, 100, 100, 100, block.timestamp + needsFulfillTimer, false, false, false, false, true));
        _safeMint(_to,id);
        return id;
    }

    function balances(address _address) external view returns (uint){
        return balanceOf(_address);
    }

    function _triggerTimer(uint _id) internal {
        citizens[_id].needsFulfillTime = block.timestamp + needsFulfillTimer;
    }
    function isFulfillNeeded(uint _id) internal view returns (bool){
        return (citizens[_id].needsFulfillTime <= block.timestamp);
    }
    function fulfillNeeds(uint _id) onlyCitizenOwner(_id) public {
        require(isFulfillNeeded(_id) == false, "There is still time");
        require(576 <= IAnyElectricityToken(electricity).balances(ownerOf(_id)) && 7752 <= IAnyFoodToken(food).balances(ownerOf(_id)) && 12 <= IAnyWaterToken(water).balances(ownerOf(_id)),"Resources not enough!");
        IAnyElectricityToken(electricity).burn(ownerOf(_id), 576);
        IAnyFoodToken(food).burn(ownerOf(_id), 7752);
        IAnyWaterToken(water).burn(ownerOf(_id), 12);
        _triggerTimer(_id);
        citizens[_id].needsFulfilled = true;
    }
    
    function produceElectricity(uint _id) onlyCitizenOwner(_id) isProducing(_id) public {
        citizens[_id].startTime = block.timestamp;
        citizens[_id].ef = true;
    }
    
    function stopProduceElectricity(uint _id) onlyCitizenOwner(_id) shiftTimer(_id) public {
        require(citizens[_id].ef == true, "You are not producing electricity!");
        uint productiveTime = block.timestamp - citizens[_id].startTime;
        citizens[_id].ef = false;
        uint daysSpend = productiveTime / 86400;
        citizens[_id].ss += 6 * daysSpend;
        citizens[_id].ms += 5 * daysSpend;
        citizens[_id].cs += 6 * daysSpend;
        IAnyElectricityToken(electricity).mint(ownerOf(_id), electricityAllowance(productiveTime));
    }
    function electricityAllowance(uint _productiveTime) internal pure returns(uint) {
        uint allowance = _productiveTime % 1000;
        if(_productiveTime % 1000 <= 576){return 576;} else{return allowance;}
    }

    function produceFood(uint _id) onlyCitizenOwner(_id) isProducing(_id) public {
        citizens[_id].startTime = block.timestamp;
        citizens[_id].ff = true;
    }
    function stopProduceFood(uint _id) onlyCitizenOwner(_id) shiftTimer(_id) public {
        require(citizens[_id].ff == true, "You are not producing food!");
        uint productiveTime = block.timestamp - citizens[_id].startTime;
        citizens[_id].ff = false;
        uint daysSpend = productiveTime / 86400;
        citizens[_id].ss += 6 * daysSpend;
        citizens[_id].ms += 7 * daysSpend;
        citizens[_id].cs += 5 * daysSpend;
        IAnyFoodToken(food).mint(ownerOf(_id), foodAllowance(productiveTime));
    }
    function foodAllowance(uint _productiveTime) internal pure returns(uint) {
        uint allowance = _productiveTime % 10000;
        if(_productiveTime % 10000 <= 7752){return 7752;} else{return allowance;}
    }

    function produceWater(uint _id) onlyCitizenOwner(_id) isProducing(_id) public {
        citizens[_id].startTime = block.timestamp;
        citizens[_id].wf = true;
    }
    function stopProduceWater(uint _id) onlyCitizenOwner(_id) shiftTimer(_id) public {
        require(citizens[_id].wf == true, "You are not producing water!");
        uint productiveTime = block.timestamp - citizens[_id].startTime;
        citizens[_id].wf = false;
        uint daysSpend = productiveTime / 86400;
        citizens[_id].ss += 6 * daysSpend;
        IAnyWaterToken(water).mint(ownerOf(_id), waterAllowance(productiveTime));
    }
    function waterAllowance(uint _productiveTime) internal pure returns(uint) {
        uint allowance = _productiveTime % 100;
        if(_productiveTime % 100 <= 12){return 12;} else{return allowance;}
    }

    function produceOre(uint _id) onlyCitizenOwner(_id) isProducing(_id) public {
        citizens[_id].startTime = block.timestamp;
        citizens[_id].mf = true;
    }
    function stopProduceOre(uint _id) onlyCitizenOwner(_id) shiftTimer(_id) public {
        require(citizens[_id].mf == true, "You are not producing water!");
        uint productiveTime = block.timestamp - citizens[_id].startTime;
        uint allowance = productiveTime % 100;
        citizens[_id].mf = false;
        uint daysSpend = productiveTime / 86400;
        citizens[_id].ss += 7 * daysSpend;
        citizens[_id].ms += 6 * daysSpend;
        citizens[_id].cs += 7 * daysSpend;
        IAnyOreToken(ore).mint(ownerOf(_id), allowance);
    }

    function getCitizenSkills(uint _id) external view returns(uint sSkill, uint mSkill, uint cSkill, uint aggSkill) {
        sSkill = citizens[_id].ss; 
        mSkill = citizens[_id].ms; 
        cSkill = citizens[_id].cs;
        aggSkill = sSkill + mSkill + cSkill;
    }
    
    function setAddresses(address _acm, address _cluster, address _electricity, address _food, address _water, address _ore) onlyOwner public returns(bool) {
        acm = _acm;
        cluster = _cluster;
        electricity = _electricity;
        food = _food;
        water = _water;
        ore = _ore;
        return true;
    }

    function _ownerOf(uint256 tokenId) external view returns (address) {
        return ownerOf(tokenId);
    }
    
    modifier onlyCluster() {
        require(msg.sender == cluster);
        _;
    }
    modifier onlyACM() {
        require(msg.sender == acm);
        _;
    }
    modifier onlyCitizenOwner(uint _id) {
        require(msg.sender == ownerOf(_id), "You don't own me. I'm not just one of your many toys.");
        _;
    }
    modifier shiftTimer(uint _id) {
        require(citizens[_id].startTime + 86400 <= block.timestamp, "Complete your shift before out!");
        _;
    }
    modifier isProducing(uint _id) {
        require( citizens[_id].ef == false && citizens[_id].ff == false && citizens[_id].wf == false && citizens[_id].mf == false, "Citizen already producing resources!");
        _;
    }
}
    interface IAnyElectricityToken {
        function mint(address account, uint256 amount) external returns(bool);
        function burn(address account, uint256 amount) external returns(bool);
        function balances(address _address) external view returns (uint);
    }
    interface IAnyFoodToken {
        function mint(address account, uint256 amount) external returns(bool);
        function burn(address account, uint256 amount) external returns(bool);
        function balances(address _address) external view returns (uint);
    }
    interface IAnyWaterToken {
        function mint(address account, uint256 amount) external returns(bool);
        function burn(address account, uint256 amount) external returns(bool);
        function balances(address _address) external view returns (uint);
    }
    interface IAnyOreToken {
        function mint(address account, uint256 amount) external returns(bool);
        function burn(address account, uint256 amount) external returns(bool);
        function balances(address _address) external view returns (uint);
    }