// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.9.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract AnyElectricityToken is ERC20, Ownable {
    address public _owner;
    address private CTZN;

    constructor() ERC20("Any Electricity Token", "eANY") {
        _owner = msg.sender;
    }
    
    function mint(address account, uint256 amount) external onlyCitizen returns(bool) {
         _mint(account, amount);
         return true;
    }
    
    function burn(address account, uint256 amount) external onlyCitizen returns(bool) {
         _burn(account, amount);
         return true;
    }

    function balances(address _address) external view returns (uint){
        return balanceOf(_address);
    }
    
    function setCitizenAddress(address _citizen) onlyOwner public returns (address) {
        return CTZN = _citizen;
    }
    
    modifier onlyCitizen() {
        require(msg.sender == CTZN);
        _;
    }
}