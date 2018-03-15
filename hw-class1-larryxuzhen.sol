pragma solidity ^0.4.14;
contract Payroll {
    
    address owner = msg.sender;
    address employee;
    
    uint salary = 1 ether;
    uint constant payDuration = 10 seconds;
    uint lastPayDay = now;
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunaway() returns (uint){
        return this.balance/salary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunaway()>0;
    }

    function getPaid(){
        require(msg.sender == employee);
        uint nextPayDay = lastPayDay + payDuration;
        if(nextPayDay > now){
            revert();
        }
        lastPayDay = nextPayDay;
        employee.transfer(salary);
    }
    
    //test: show address 
    function ownerAddress() returns(address){
        return owner;
    }
    function employeeAddress() returns(address){
        return employee;
    }
    
    //show the balance of employee, this employee can do it
    function getEmployeeBalance() returns(uint){
        require(msg.sender == employee);
        return employee.balance;
    }
    
    //initialize the employee's address, the owner can do it
    function iniEmployee(address iniAddress) returns(address){
        require(msg.sender == owner && employee == 0x0 && iniAddress != 0x0);
        employee = iniAddress;
        return employee;
    }
    
    //change the employee, the owner can do it
    function chgAddress(address newAddress) returns(address){
        require(msg.sender == owner && newAddress != 0x0); 
        clearUnpaid();
        lastPayDay = now;
        employee = newAddress;
        return employee;
    }
    
    //change the salary of employee, the owner can do it, using ether as unit
    function chgSalary(uint newSalary) returns(uint){
        require(msg.sender == owner);
        clearUnpaid();
        salary = newSalary * 1 ether;
        return salary;
    }
    
    //clear the remaining unpaid money
    function clearUnpaid() payable{
        uint payment = salary * ((now-lastPayDay) / payDuration);   
        if(payment > 0){
            lastPayDay = now;
            employee.transfer(payment);
        }
    }
    
}
