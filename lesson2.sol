
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
    
    Employee[] employees;
    
    function _patialPaid(Employee employee) private {
          uint payment = employee.salary *(now - employee.lastPayday)/payDuration;
          //如果当前合约上有员工，则先给该员工进行结算
           employee.id.transfer(payment);
           
           
    }
    
    function _findemployee(address employeeid) private returns (Employee,uint)
    //（Employee storage，uint）返回一个存贮地址，否则是内存地址
    {
        for(uint i = 0; i < employees.length; i++)
        {
             if(employees[i].id == employeeid){
                 return (employees[i],i);//return two values
             }
        }
    }
    
    function addEmployee(address employeeid, uint salary)
    {
        
        //require(msg.sender == owner);
        
        /*for(uint i = 0;i < employees.length; i++)
        {
            if(employees[i].id == employee)
            {
                revert;
            }
        }*///jianhua
        var (em, index)= _findemployee(employeeid);//get two returns
        assert(em.id == 0x0);//address is null不存在此员工
        employees.push(Employee(employeeid,salary * 1 ether,now));
        
        total = total + salary * 1 ether;
    }

    function removeEmployee(address employeeid)
    {
        //require(msg.sender == owner);
        
        /*for(uint i = 0; i < employees.length; i++)
        {
            
            delete employees[i];//删除第i位置上的值
            employees[i] = employees[employees.length - 1]; //补上空隙
            employees.length -=1;//重新调整长度
            return;
        }*/
        
        var (em, index)= _findemployee(employeeid);//get two returns
        assert(em.id !=0x0);
        
        _patialPaid(employees[index]);//
        delete employees[index];//删除第i位置上的值
         employees[index] = employees[employees.length - 1]; //补上空隙
        employees.length -=1;//重新调整长度
        
        total = total - em.salary;
    }

    
    function Payroll()
    {
       owner = msg.sender;
    }
    
    function updateEmployee(address employeeid ,uint salary )
    {
        
        
        //if(msg.sender != owner)//确定是合约创建者
        //{
        //   revert();
        //}//简化如下：
        //require(msg.sender == owner);
        
        var (em, index)= _findemployee(employeeid);//get two returns
        assert(em.id != 0x0);
        

        _patialPaid(em);//
       
        //**em是个内存变量
        //em.salary = salary * 1 ether;//fait mal
        //**所以直接修改em值，并不是修改成员变量employee的值。他们之间是拷贝关系
        
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
        
        total = total - em.salary + salary * 1 ether;
    }

    
    function addFund() payable returns(uint)//with payable, this contract can accept money directly
    {
        return this.balance;
    }
    
    function calculateRunway() returns(uint){
        uint totalsalary = 0;
        
        for(uint i = 0; i < employees.length; i++)
        {
            totalsalary = totalsalary + employees[i].salary;
        }
        
       return this.balance/totalsalary;
      
    }
    
    function calculateRunwayNew() returns(uint){//renewed calculateRunway function
        return this.balance/total;
    }
    
    //function hasEnouFund() returns (bool){
     //   return calculateRunway()>0;
    //}
    
    function getPaid() {
        //if(msg.sender != employee)
       // {
       //     revert();
       // }//简化如下
       // require(msg.sender == employee);
        
        var (em, index)= _findemployee(msg.sender);//get two returns
        assert(em.id != 0x0);
        
        
        
        uint nextPayday = em.lastPayday + payDuration; 
        
        //if(nextPayday > now)
        //{
        //    revert();
        //}//简化如下：
        assert(nextPayday < now);//运行时判断
        
        employees[index].lastPayday = nextPayday;//quand on paie, il faut changer les properties avant transfer.
        em.id.transfer(em.salary);
        
    }
}
