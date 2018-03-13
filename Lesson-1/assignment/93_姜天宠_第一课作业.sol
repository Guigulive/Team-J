/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary; //我认为此处没必要初始化 若calculateRunway调用报错即可
    address employee;
    uint lastPayday;
    

    function Payroll() {
        owner = msg.sender;
    }
    
    function updateSalary(uint s) {
        require(msg.sender == owner);
        // 先把工资变化前的薪水结清
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    function updateEmployee(address e){
        require(msg.sender == owner);
        // 先把上一个employee的薪水结清
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        lastPayday = now;
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
    
    function getPaid() {
        require(msg.sender == employee);
        uint nextPayday = lastPayday + payDuration;
        
        require(nextPayday < now);
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
