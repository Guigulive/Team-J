pragma solidity ^0.4.14;

contract Payroll {

    // 自定义结构体
    struct Employee {
        address id; // 钱包地址
        uint salary; // 工资
        uint lastPayday; // 上一次支付工资时间
    }
    
    uint constant payDuration = 10 seconds; // 为方便调试，定义薪水周期为10秒
    uint totalSalary = 0;
    
    address owner; // 老板
    // 在Storage上存储，不使用数组+链表
    mapping(address => Employee) public employees;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    modifier onlyOwner{
        require(msg.sender == owner);
        _; 
    }
    
    modifier employeeExist(address employeeId){
        var employee  = employees[employeeId];
        assert(employee.id != 0*0);
        _; // 代表所修饰的函数，return以外的语句
    }
    
    // 结清指定员工工资
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    // 添加员工
    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee  = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now );
        totalSalary += employees[employeeId].salary;
    }
    
    // 删除员工
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
        var employee  = employees[employeeId];
        totalSalary -= employee.salary;
        _partialPaid(employee); // 结清工资
        delete employees[employeeId]; // 初始化该位置

    }
    
    // 调整指定员工工资
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){
        var employee  = employees[employeeId];
        _partialPaid(employee); // 结清工资
        totalSalary -= employees[employeeId].salary;
        employees[employeeId].salary = salary * 1 ether;
        totalSalary += employees[employeeId].salary;
        employees[employeeId].lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    /* 使用 public 可以删掉以下函数
    // 命名参数返回
    function checkEmployee(address employeeId) returns (uint salary, uint lastPayday){
        var employee = employees[employeeId];
        // 命名参数返回可以直接赋值
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    */
    
    function getPaid() employeeExist(msg.sender){
        var employee  = employees[msg.sender];
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}


