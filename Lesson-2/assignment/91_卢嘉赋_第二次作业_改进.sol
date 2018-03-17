pragma solidity ^0.4.14;

contract Payroll {

    // 自定义结构体
    struct Employee {
        address id; // 钱包地址
        uint salary; // 工资
        uint lastPayday; // 上一次支付工资时间
    }
    
    uint constant payDuration = 10 seconds; // 
    uint totalSalary = 0;
    为方便调试，定义薪水周期为10秒

    address owner; // 老板
    Employee[] employees; // 员工们

    function Payroll() {
        owner = msg.sender;
    }
    
    // 结清指定员工工资
    function _partialPaid(Employee employee) private {
    	uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
    	employee.id.transfer(payment);
    }
    
    // 定位数组中指定ID的员工
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++){
            if ( employees[i].id == employeeId){
                return (employees[i], i);
            }
        }
    }

    // 添加员工
    function addEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId,salary * 1 ether,now));
        totalSalary += salary * 1 ether;
    }
    
    // 删除员工
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0*0);

        totalSalary -= employee.salary;
        _partialPaid(employee); // 结清工资
        delete employees[index]; // 初始化该位置
        employees[index] = employees[employees.length - 1]; // 将最后一位调整到该位置
        employees.length -= 1; // 员工总数减一

    }
    
    // 调整指定员工工资
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0*0);
        
        _partialPaid(employee); // 结清工资
        employees[index].salary = salary;
        employees[index].lastPayday = now;
        
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
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0*0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}


