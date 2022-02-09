// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.9.0;

import '@openzeppelin/contracts/access/Ownable.sol';

contract AnyCivilizationGame is Ownable {
    address private _owner;
    address private _ctzn;
    address private _clstr;
    
    constructor() {
        _owner = msg.sender;
    }

    function createCluster() payable public returns(bool) {
        require(msg.value >= IClusterGenerator(_clstr).clusterPrice(), "Wrong fee");
        require(ICitizenG(_ctzn).balances(msg.sender) >= 1, "You should have at least 1 citizen.");
        IClusterGenerator(_clstr).generateCluster(msg.sender);
        return true;
    }
    
    function createCitizen(uint amount) payable public{
        require(msg.value >= (0.1 ether * amount) , "Wrong fee");
        for (uint i=0; i < amount; i++) {
            ICitizenG(_ctzn).unfrozeCitizen(msg.sender);
        }
    }

    function setAddresses(address AnyCitizen, address AnyCluster) onlyOwner public {
        _ctzn = AnyCitizen;
        _clstr = AnyCluster;
    }

    function withdraw() onlyOwner public {
    payable(_owner).transfer(address(this).balance);
  }
}
    interface IClusterGenerator {
        function generateCluster(address _to) payable external returns (uint);
        function clusterPrice() external payable returns(uint);
    }

    interface ICitizenG {
        function unfrozeCitizen(address  _to) payable external returns (uint);
        function _ownerOf(uint256 tokenId) external view returns (address);
        function balances(address _address) external view returns (uint);
    }
