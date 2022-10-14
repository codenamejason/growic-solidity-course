pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";

error InsufficientBalance(uint256 balance);
error AmountToSmall();
error BalanceToSmall();
error ZeroAddress();

contract UserManagement is Ownable {
    uint256 private Fee = 0.001 ether;

    enum Status {
        Pending,
        Accepted,
        Rejected
    }
    struct Student {
        address studentId;
        string name;
        uint256 age;
        Status status;
        uint256 balance;
    }

    mapping(address => Student) public students;

    modifier hasDeposited(address studentId) {
        if (students[studentId].balance == 0) revert BalanceToSmall();
        _;
    }

    function addFund(uint256 amount) public hasDeposited(msg.sender) {
        if (amount < Fee) revert AmountToSmall();
        students[msg.sender].balance += amount;
    }

    function deposit(uint256 amount) public payable {
        if (amount == 0) revert AmountToSmall();
        if (msg.sender == address(0)) revert ZeroAddress();
        students[msg.sender].balance += amount;
    }

    function withdraw(uint256 amount) public onlyOwner {
        if (students[msg.sender].balance < amount)
            revert InsufficientBalance(students[msg.sender].balance);
        students[msg.sender].balance -= amount;
        payable(msg.sender).transfer(amount);
    }

    function checkBalance() public view returns (uint256) {
        return students[msg.sender].balance;
    }

    function getUserBalance(address userAddress) public view returns (uint256) {
        return students[userAddress].balance;
    }

    function setNewUserDetails(string memory name, uint256 age) public {
        students[msg.sender] = Student(
            msg.sender,
            name,
            age,
            Status.Pending,
            0
        );
    }

    function updateUserDetails(string memory name, uint256 age) public {
        Student storage student = students[msg.sender];
        student.name = name;
        student.age = age;
    }

    function getUserDetails(address userAddress)
        public
        view
        returns (Student memory)
    {
        return students[userAddress];
    }
}
