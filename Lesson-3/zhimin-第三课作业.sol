pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    
    uint totalSalary = 0;

    address owner;
    mapping(address => Employee) employees;
    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }
    
    modifier employeeExist(address employeeId) {
         var employee  = employees[employeeId];
         require(employee.id != 0x0);
         _;
    }
   
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPay(Employee employee) private  {
        uint owned_payment =  (now - employee.lastPayday) * employee.salary / payDuration;
        employee.id.transfer(owned_payment);
    }
    
    function addEmployee(address employeeId, uint salary) ownerOnly {
        var employee = employees[employeeId];
        require(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
        totalSalary += salary * 1 ether;
    }
    
    function updatePaymentAddress(address newAddress) employeeExist(msg.sender) {
         var employee = employees[msg.sender];
         employees[newAddress] = Employee(newAddress, employee.salary, employee.lastPayday);
         delete employees[msg.sender];
    }
    
    function removeEmployee(address employeeId) ownerOnly {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _partialPay(employee);
        totalSalary -= employee.salary;
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        
        _partialPay(employee);
        employees[employeeId].salary =  salary * 1 ether;
        employees[employeeId].lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        require(totalSalary !=0);
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        Employee employee = employees[msg.sender];
        require( employee.lastPayday + payDuration < now);
        employee.lastPayday +=  payDuration;
        employee.id.transfer(employee.salary);
    }
}
