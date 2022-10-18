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

    event FundsDeposited(address sender, uint256 amount);
    event StudentUpdated(address studentId);

    modifier hasDeposited(address studentId) {
        if (students[studentId].balance == 0) revert BalanceToSmall();
        _;
    }

    function addFund(uint256 amount) public hasDeposited(msg.sender) {
        if (amount < Fee) revert AmountToSmall();
        students[msg.sender].balance = students[msg.sender].balance + amount;
    }

    function deposit(uint256 amount) public payable {
        if (amount == 0) revert AmountToSmall();
        if (msg.sender == address(0)) revert ZeroAddress();
        students[msg.sender].balance = students[msg.sender].balance + amount;

        emit FundsDeposited(msg.sender, amount);
    }

    function withdraw(uint256 amount) public onlyOwner {
        if (students[msg.sender].balance < amount)
            revert InsufficientBalance(students[msg.sender].balance);
        students[msg.sender].balance = students[msg.sender].balance - amount;
        payable(msg.sender).transfer(amount);
    }

    function checkBalance() public view returns (uint256) {
        return students[msg.sender].balance;
    }

    function getStudentBalance(address studentId)
        public
        view
        returns (uint256)
    {
        return students[studentId].balance;
    }

    function setNewStudentDetails(
        address studentId,
        string memory name,
        uint256 age
    ) public {
        students[studentId] = Student(studentId, name, age, Status.Pending, 0);

        emit StudentUpdated(studentId);
    }

    function updateStudentDetails(
        address studentId,
        string memory name,
        uint256 age
    ) public {
        Student storage student = students[studentId];
        student.name = name;
        student.age = age;

        emit StudentUpdated(studentId);
    }

    function getUserDetails(address studentId)
        public
        view
        returns (Student memory)
    {
        return students[studentId];
    }

    receive() external payable {
        deposit(msg.value);
    }

    fallback() external payable {
        deposit(msg.value);
    }
}
