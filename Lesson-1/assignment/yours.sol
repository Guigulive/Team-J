/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll{
    uint salary; //= 1 wei;
    address frank; //=0xca35b7d915458ef540ade6068dfe2f44e8fa733c ; //-->account
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function setEmployee(address x)
    {
        frank = x;
    }
    
    function getEmployee() returns(address)
    {
        return frank;
    }
    
    function setSalary(uint x)
    {
        salary = x;
    }
    
    function getSalary() returns(uint)
    {
        return salary;
    }
    
    function addFund() payable returns(uint)//with payable, this contract can accept money directly
    {
        return this.balance;
    }
    
    function calculateRunway() returns(uint){
        return this.balance/salary;
    }
    
    function hasEnouFund() returns (bool){
        return calculateRunway()>0;
    }
    
    function getPaid() {
        //if(msg.sender != frank)
       // {
         //   revert();
       // }
        
        uint nextPayday = lastPayday + payDuration; 
        if(nextPayday > now)
        {
            revert();
        }
        
        lastPayday = nextPayday;//quand on paie, il faut changer les properties avant transfer.
        frank.transfer(salary);
        
    }
}
