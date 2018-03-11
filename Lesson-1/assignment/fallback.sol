pragma solidity ^0.4.14;

contract Payroll {
    
    uint salary = 1 ether; 
    address payee;
    
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function setPayee(address addr){
        payee = addr;
    }
    
    function setSalary(uint amount){
        salary = amount;
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
