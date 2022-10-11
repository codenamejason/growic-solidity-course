pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./UserManagement.sol";

import "hardhat/console.sol";

error NotOwner();

contract Admissions is Ownable {
  mapping(address => UserManagement.Student) public students;

  constructor() payable {
    if(msg.sender != owner()) revert NotOwner();
    
    // transferOwnership(msg.sender);
  }

  function registerStudent(address studentId, string memory name, uint256 age) public onlyOwner {
    students[studentId] = UserManagement.Student(studentId, name, age, UserManagement.Status.Pending, 0);
  }

  function getStudentDetails(address studentId) public view returns (UserManagement.Student memory) {
    return students[studentId];
  }
}