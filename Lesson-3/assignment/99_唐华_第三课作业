/*作业请提交在这个目录下*/

pragma solidity ^0.4.14;

contract Payroll{
    uint constant payDuration = 10 seconds;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }
        
    uint totalSalary;
    
    address owner;
    //Employee []employees;
    mapping(address => Employee) employees;
    
    //construct function：owner who create this contract
    function Payroll() {
        owner = msg.sender; 
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier oldEmployeeExist(address oldEmployeeId) {
        var employee = employees[oldEmployeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    //employee only get once in a payDuration
    function _patialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayDay) / payDuration;
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner {
        
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
        
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _patialPaid(employee);
        
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];//delete employee but blank
    
    }
    
    function updateEmployee(address employeeId,uint salary) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        
        _patialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        
        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayDay = now;
        totalSalary += employees[employeeId].salary;
    }
    
    function changePaymentAddress(address oldEmployeeId, address newEmployeeId) onlyOwner oldEmployeeExist(oldEmployeeId){
        var employee = employees[newEmployeeId]; 
        employees[oldEmployeeId] = employee;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint){
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    function checkEmployee(address employeeId) returns (uint salary, uint lastPayDay){
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayDay = employee.lastPayDay;
    }
    
    function getPaid() employeeExist(msg.sender){
   
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayDay + payDuration;
        if(nextPayday > now){
            revert();
        }
        
        employees[msg.sender].lastPayDay = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
}

问题二：更改员工薪水支付地址:
    modifier oldEmployeeExist(address oldEmployeeId) {
        var employee = employees[oldEmployeeId];
        assert(employee.id != 0x0);
        _;
    }

    function changePaymentAddress(address oldEmployeeId, address newEmployeeId) onlyOwner oldEmployeeExist(oldEmployeeId){
        var employee = employees[newEmployeeId]; 
        employees[oldEmployeeId] = employee;
    }
