pragma solidity ^0.4.14;

contract Payroll {
    
    uint constant payDuration = 10 seconds;
    
    address employee;
    address employer;
    uint salary = 1 ether;
    uint lastPayday;
     
    // init
    function Payroll() {
        employer = msg.sender;
    }
    // payable keyword is used to receive money
    function addFund() payable public returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public {
        require(msg.sender == employee);
        uint nextPayDay = lastPayday + payDuration;
        require(nextPayDay <= now);
        lastPayday = nextPayDay;
        employee.transfer(salary);
    }
    
    function updateEmployeeAddress(address addr) {
        require(msg.sender == employer);
        clearUnpaid();
        employee = addr;
    }
    
    // salary unit is ether
    function updateSalary(uint s) {
        require(msg.sender == employer);
        clearUnpaid();
        salary = s * 1 ether;
    }
    
    function clearUnpaid() private{
        if (employee != 0x0) {
            uint unpaid = salary * (now - lastPayday) / payDuration;
            employee.transfer(unpaid);
        }
        lastPayday = now;
    }
    
}
