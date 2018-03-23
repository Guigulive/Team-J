/*作业请提交在这个目录下*/
//关于modifier整合 我觉得现阶段没有过多的，因此整合没有意义
//另外现阶段的employeeExist导致 var employee = employees[employeeId];语句两次出现 感觉很冗余

pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;
    
    uint totalSalary = 0; 

    address owner;
    mapping(address => Employee) public employees;
    
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employeeId != 0x0);
        _;
    }

    
    function _partialPaid(Employee employee) private{
        //uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.id.transfer(payment);
    }

    
    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        //totalSalary += salary * 1 ether;
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        //totalSalary -= employees[employeeId].salary; 
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
    }

    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        // totalSalary -= employees[employeeId].salary;
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].salary = salary.mul(1 ether);
        // totalSalary += employees[employeeId].salary;
        totalSalary = totalSalary.add(employees[employeeId].salary);
        employees[employeeId].lastPayday = now;
    }
    
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        // return this.balance / totalSalary;
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    

    function changePaymentAddress(address newaddress) employeeExist(msg.sender){
        var employee = employees[msg.sender];
        var newemployee = employees[newaddress];
        employees[newaddress] = Employee(newaddress, employee.salary, now);

        delete employees[msg.sender];
    }
    
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        
        //uint nextPayday = employee.lastPayday + payDuration;
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}


