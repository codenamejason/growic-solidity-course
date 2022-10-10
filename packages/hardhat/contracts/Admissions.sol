pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";

error NotOwner();

contract Admissions is Ownable {

  enum Status { Pending, Accepted, Rejected }

  struct Student {
    address studentID;
    Status status;
  }

  mapping(address => Student) public students;

  constructor() payable {
    if(msg.sender != owner()) revert NotOwner();
    
    // transferOwnership(msg.sender);
  }

  function registerStudent(address studentID) public onlyOwner {
    students[studentID] = Student(studentID, Status.Pending);
  }

  function getStudentDetails(address studentID) public view returns (Student memory) {
    return students[studentID];
  }
}