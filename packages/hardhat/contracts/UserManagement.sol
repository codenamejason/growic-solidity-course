pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";

error InsufficientBalance(uint256 balance);
error ZeroValue();
error ZeroAddress();

contract UserManagement {
    enum Status { Pending, Accepted, Rejected }
    struct Student {
        address studentId;
        string name;
        uint256 age;
        Status status;
        uint256 balance;
    }
    
    mapping(address => Student) public students;
    
    function deposit(uint256 amount) public payable {
        if(amount == 0) revert ZeroValue();
        if(msg.sender == address(0)) revert ZeroAddress();
        students[msg.sender].balance += amount;
    }
    
    function withdraw(uint256 amount) public {
        if(students[msg.sender].balance < amount) revert InsufficientBalance(students[msg.sender].balance);
        students[msg.sender].balance -= amount;
        payable(msg.sender).transfer(amount);
    }

    function checkBalance() public view returns (uint256) {
        return students[msg.sender].balance;
    }

    function getUserBalance(address userAddress) public view returns (uint256) {
        return students[userAddress].balance;
    }

    function setUserDetails(string memory name, uint256 age) public {
        students[msg.sender] = Student(msg.sender, name, age, Status.Pending, 0);
    }
    
    function getUserDetails(address userAddress) public view returns (Student memory) {
        return students[userAddress];
    }
}