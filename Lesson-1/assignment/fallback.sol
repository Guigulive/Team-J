pragma solidity ^0.4.14;

contract Payroll {
    
    uint salary = 1 ether; 
    address payee;
    address owner;
    
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    function Payroll(){
        owner = msg.sender;
    }

    function updateEmployee(address addr, uint s){
        require(msg.sender == owner);
        if (payee != 0x0){
            uint payment = salary * (now - lastPayday )/payDuration;
            payee.transfer(payment);
        }
        payee = addr;
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint){
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway()>0;
    }
    
    function getPaid(){
        require(msg.sender == owner);
        uint nextPayDay = lastPayday + payDuration;
        
        if(nextPayDay > now){
            revert();
        }
        if(!hasEnoughFund()){
            revert();
        }
        
        lastPayday = nextPayDay;
        payee.transfer(salary);
    }
}

