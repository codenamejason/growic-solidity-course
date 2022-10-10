pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";

error InsufficientBalance(uint256 balance);

contract UserBalance {
    mapping(address => uint256) public balances;
    
    function deposit(uint256 amount) public payable {
        balances[msg.sender] += amount;
    }
    
    function withdraw(uint256 amount) public {
        if(balances[msg.sender] < amount) revert InsufficientBalance(balances[msg.sender]);
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function checkBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}