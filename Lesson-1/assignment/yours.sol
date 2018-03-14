/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint salary = 1 ether;
    address boss;
    address employee;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function Payroll() payable {
        boss = msg.sender;
    }
    
    function updateEmployee(address new_employee) {
        require (msg.sender == boss);
        require (new_employee == 0x0);
        employee = new_employee;
    }
    
    function updateSalary(uint new_salary) {
        require (msg.sender == boss) ;
        salary = new_salary * 1 ether ;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0; 
    }
    
    function getBalance() returns (uint) {
        return this.balance;    
    }
    
    function getPaid() payable {
        require(msg.sender == employee);
        uint nextPayDay = lastPayday + payDuration;
        require(nextPayDay < now);
        lastPayday = nextPayDay;
        employee.transfer(salary);
    }
}
