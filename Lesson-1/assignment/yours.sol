/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll{
    uint salary; //= 1 wei;
    address employee; //=0xca35b7d915458ef540ade6068dfe2f44e8fa733c ; //-->account
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    address owner;
    
    function Payroll()
    {
       owner = msg.sender;
    }
    
    function updateEmployee(address x ,uint y )
    {
        
        //if(msg.sender != owner)//确定是合约创建者
        //{
        //   revert();
        //}//简化如下：
        require(msg.sender == owner);
        
        if(employee!= 0x0)
        {
           uint payment = salary *(now - lastPayday)/payDuration;//如果当前合约上有员工，则先给该员工进行结算
           employee.transfer(payment);
        }
        

            employee = x;
            salary = y* 1 ether;//保证单位
            lastPayday = now;
        
    }
    
    function getEmployee() returns(address)
    {
        return employee;
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
        //if(msg.sender != employee)
       // {
       //     revert();
       // }//简化如下
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration; 
        
        //if(nextPayday > now)
        //{
        //    revert();
        //}//简化如下：
        assert(nextPayday < now);//运行时判断
        
        lastPayday = nextPayday;//quand on paie, il faut changer les properties avant transfer.
        employee.transfer(salary);
        
    }
}
