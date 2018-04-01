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
    
    uint constant PAY_DURATION = 10 minutes;
    mapping(address => Employee) public employees;
    uint totalSalary;
    address[] employeeList;

    event NewEmployee(address employeeId);
    event RemoveEmployee(address employeeId);
    event UpdateEmployee(address employeeId);
    event NewFund(uint balance);
    event GetPaid(address employeeId);
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(PAY_DURATION);
        assert(this.balance >= payment);
        employee.id.transfer(payment);
    }
    
    function addFund() payable returns (uint) {
        NewFund(this.balance);
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        if (totalSalary < 1) {
            return 0;
        }
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        
        uint nextPayDay = employee.lastPayday.add(PAY_DURATION);
        assert(nextPayDay < now);
        
        employee.lastPayday = nextPayDay;
        employee.id.transfer(employee.salary);

        GetPaid(employee.id);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        uint s = salary * 1 ether;
        totalSalary = totalSalary.add(s);
        employees[employeeId] = Employee(employeeId, s, now);
        employeeList.push(employeeId);
        NewEmployee(employeeId);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
        
        // 删除员工地址
        for (uint index = 0; index < employeeList.length; index++) {
            if (employeeList[index] == employeeId) {
                delete employeeList[index];
                employeeList[index] = employeeList[employeeList.length - 1];
                employeeList.length -= 1;
                 break;
            }
        }

        RemoveEmployee(employeeId);
    }

    function updateEmployee(address employeeId, uint s) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        totalSalary = totalSalary.sub(employee.salary);
        _partialPaid(employee);
        employee.lastPayday = now;
        employee.salary = s * 1 ether;
        totalSalary = totalSalary.add(employee.salary);
        UpdateEmployee(employeeId);
    }
    
    // 修改员工薪水支付地址
    function changePaymemntAddress(address newAddress) employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        employee.id = newAddress;
        employees[newAddress] = employee;
        delete employees[msg.sender];
    }

    // 获取合约信息
    function getInfo() returns (uint balance, uint runway, uint employeeCount) {
        balance = this.balance;
        runway = calculateRunway();
        employeeCount = employeeList.length;
    }

    // 获取员工信息
    function getEmployeeInfo(uint index) returns (address employeeId, uint salary, uint lastPaidDay) {
        employeeId = employeeList[index];
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPaidDay = employee.lastPayday;
    }
    
}
