// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.9.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract AnyGameToken is ERC20, Ownable {
    address public _owner;
    address private _clstr;

    constructor(uint256 _initialSupply) ERC20("Any Game Token", "ANY") {
        _owner = msg.sender;
        _mint(_owner, _initialSupply);
    }
    
    function mint(address account, uint256 amount) external onlyCLSTR returns(bool) {
         _mint(account, amount);
         return true;
    }
    
    function burn(address account, uint256 amount) external onlyCLSTR returns(bool) {
         _burn(account, amount);
         return true;
    }
    
    function balances(address _address) external view returns (uint){
        return balanceOf(_address);
    }

    function setCLSTRAddress(address AnyCluster) onlyOwner public returns(address) {
        return _clstr = AnyCluster;
    }
    
    modifier onlyCLSTR() {
        require(msg.sender == _clstr);
        _;
    }
}