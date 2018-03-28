pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;

    struct Employee {
        address id; 
        uint salary; 
        uint lastPayday; 
    }
    
    uint constant payDuration = 10 seconds; 
    uint public totalSalary = 0;
    
    address owner; 
    mapping(address => Employee) public employees;
    
    
    modifier employeeExist(address employeeId){
        var employee  = employees[employeeId];
        assert(employee.id != 0*0);
        _; 
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner public {
        var employee  = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now );
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public {
        var employee  = employees[employeeId];
        totalSalary = totalSalary.sub(employee.salary);
        _partialPaid(employee); 
        delete employees[employeeId]; 

    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) public {
        var employee  = employees[employeeId];
        _partialPaid(employee); 
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].salary = salary * 1 ether;
        totalSalary = totalSalary.add(employees[employeeId].salary);
        employees[employeeId].lastPayday = now;
    }
    
    function addFund() public payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }
    
    
    function getPaid() employeeExist(msg.sender) public {
        var employee  = employees[msg.sender];
        
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}


