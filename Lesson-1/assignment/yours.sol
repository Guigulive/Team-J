/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll{
    uint salary = 0 ether;
    address employee = 0x0;
    uint payDuration = 10 seconds;
    uint lastPayDay = now;
    
    function setEmployeeSalary(uint x) constant returns (uint){
        salary = x;
        return salary;
    }
    
    function setEmployeeAddress(address y) constant returns (address){
        employee = y;
        return employee;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint){
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    function getPaid() returns(uint){
        if(msg.sender != employee){
            revert();
        }
        uint nextPayday = lastPayDay + payDuration;
        if(nextPayday > now){
            revert();
        }
        
            lastPayDay = nextPayday;
            employee.transfer(salary);
    }
    
}
