//改进后calculateRunway 消耗的gas稳定为22122 850
/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;
    uint totalSalary; //用于改进calculateRunway

    address owner;
    Employee[] employees;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint){
        for (uint i = 0; i < employees.length; i ++){
            if (employees[i].id == employeeId){
                return (employees[i],i);
            }
        }
    }
    
    function addEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId,salary * 1 ether,now));
        // 改进calculateRunnway
        // 将新员工工资计入总薪水
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId){
        require(msg.sender == owner);

        var (employee, index) = _findEmployee(employeeId);
        
        assert(employeeId != 0x0);
        _partialPaid(employee);
        // 改进calculateRunnway
        // 减去已被删除员工的工资
        totalSalary -= employees[index].salary; 
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
        
    }

    
    function updateEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        // 改进calculateRunnway
        // 先减去原工资再计算加入更新工资
        totalSalary = -employees[index].salary + salary * 1 ether;
        employees[index].salary = salary * 1 ether;
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
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        
        assert(nextPayday < now);
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
