
/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll{
    
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    
 
    
    uint constant payDuration = 10 seconds;
    address owner;
    
    uint total = 0;
    
    mapping(address=>Employee) public employees;
    
    
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    
    modifier employeeExist(address employeeid){
        var em= employees[employeeid];//get two returns
        assert(em.id !=0x0);
        _;
    }
    
    
    function _patialPaid(Employee employee) private {
          uint payment = employee.salary *(now - employee.lastPayday)/payDuration;
          //如果当前合约上有员工，则先给该员工进行结算
           employee.id.transfer(payment);
    }
    
    function checkEmployee(address employeeid) returns(uint salary, uint lastPayday){
      var employee = employees[employeeid];
      salary = employee.salary;
      lastPayday = employee.lastPayday;
      //return(employee.salary, employee.lastPayday);ke可sheng'lüe
    }

    function addEmployee(address employeeid, uint salary) onlyOwner
    {
        
     
        

        var em= employees[employeeid];//get two returns
        assert(em.id == 0x0);//address is null不存在此员工
        employees[employeeid] = Employee(employeeid,salary * 1 ether,now);
        
        total = total + salary * 1 ether;
    }

    function removeEmployee(address employeeid) onlyOwner employeeExist(employeeid)
    {

        _patialPaid(employees[employeeid]);//
        var em = employees[employeeid];
        delete employees[employeeid];//删除第i位置上的值
       
        total = total - em.salary;
    }

    
    function Payroll()
    {
       owner = msg.sender;
    }
    
    function updateEmployee(address employeeid ,uint salary ) onlyOwner employeeExist(employeeid)
    {
        
        
        //if(msg.sender != owner)//确定是合约创建者
        //{
        //   revert();
        //}//简化如下：
        
        //require(msg.sender == owner);
        
        var em= employees[employeeid];//get two returns
       

        _patialPaid(em);//
       
        //**em是个内存变量
        //em.salary = salary * 1 ether;//fait mal
        //**所以直接修改em值，并不是修改成员变量employee的值。他们之间是拷贝关系
        
        employees[employeeid].salary = salary * 1 ether;
        employees[employeeid].lastPayday = now;
        
        total = total - em.salary + salary * 1 ether;
    }

    
    function addFund() payable returns(uint)//with payable, this contract can accept money directly
    {
        return this.balance;
    }
    
    
    function calculateRunwayNew() returns(uint){//renewed calculateRunway function
        return this.balance/total;
    }
    
    //function hasEnouFund() returns (bool){
     //   return calculateRunway()>0;
    //}
    function changePayadress(address newadress)
    {
        owner = newadress;
    }
    
    function getPaid() employeeExist(msg.sender){
        
        var em= employees[msg.sender];//get two returns
       
        uint nextPayday = em.lastPayday + payDuration; 
        
        //if(nextPayday > now)
        //{
        //    revert();
        //}//简化如下：
        assert(nextPayday < now);//运行时判断
        
        employees[msg.sender].lastPayday = nextPayday;//quand on paie, il faut changer les properties avant transfer.
        em.id.transfer(em.salary);
        
    }
}
