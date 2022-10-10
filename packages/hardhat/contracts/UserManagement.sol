pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";

error InsufficientBalance(uint256 balance);
error ZeroValue();
error ZeroAddress();

contract UserManagement {
    struct User {
        string name;
        uint256 age;
        uint256 balance;
    }
    
    mapping(address => User) public users;
    mapping(address => uint256) public balances;
    
    function deposit(uint256 amount) public payable {
        if(amount == 0) revert ZeroValue();
        if(msg.sender == address(0)) revert ZeroAddress();
        balances[msg.sender] += amount;
        users[msg.sender].balance += amount;
    }
    
    function withdraw(uint256 amount) public {
        if(balances[msg.sender] < amount) revert InsufficientBalance(balances[msg.sender]);
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function checkBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function getUserBalance(address userAddress) public view returns (uint256) {
        return users[userAddress].balance;
    }

    function setUserDetails(string calldata name, uint256 age, uint256 amount) public {
        users[msg.sender] = User(name, age, amount);
    }
    
    function getUserDetails(address userAddress) public view returns (User memory) {
        return users[userAddress];
    }
}