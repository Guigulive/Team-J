pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    
    uint total = 0;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPay(uint index) private {
        uint owned_payment =  (now - employees[index].lastPayday) * employees[index].salary / payDuration;
        employees[index].id.transfer(owned_payment);
    }
    
    function _findEmployee(address employeeId) private returns (int) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return int(i);
            }
        }
        return -1;
    }

    function addEmployee(address employeeId, uint salary) returns (uint) {
        require(_findEmployee(employeeId) == -1);
        employees.push(Employee(employeeId, salary * 1 ether, now));
        total += salary * 1 ether;
        return employees.length;
    }
    
    function removeEmployee(address employeeId) {
        int i = _findEmployee(employeeId);
        if (i != -1) {
            uint ui = uint(i);
            total -= employees[ui].salary;
            delete employees[ui];
            employees[ui] = employees[employees.length -1];
            employees.length -= 1;
        }
    }
    
    function updateEmployee(address employeeId, uint salary) {
        int i = _findEmployee(employeeId);
        if (i != -1) {
            uint ui = uint(i);
            _partialPay(ui);
            employees[ui].id =  employeeId;
            total -= employees[ui].salary;
            employees[ui].salary = salary * 1 ether;
            total += employees[ui].salary;
        }
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function newCalculateRunway() returns (uint) {
        require(total !=0);
        return this.balance / total;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        require(totalSalary !=0);
        return this.balance / totalSalary;
        
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        int i = _findEmployee(msg.sender);
        if (i != -1) {
            uint ui = uint(i);
            Employee employee = employees[ui];
            require( employee.lastPayday + payDuration < now);
            employees[ui].lastPayday +=  payDuration;
            employees[ui].id.transfer(employees[ui].salary);
        }
    }
}
