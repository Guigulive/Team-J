pragma solidity ^0.4.14;
import "./SafeMath.sol";
import "./Ownable.sol";
contract Payroll is Ownable{
    using SafeMath for uint;
    //struct of one employee
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    //address owner = msg.sender;
    mapping(address => Employee) public employees;
    uint totalSalary = 0;
    
    /*modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }*/
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    modifier employeeNotExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    //clear the unpaid salary
    function _partialPaid(Employee employee) private{
        uint payment = employee.salary.mul((now.sub(employee.lastPayday)).div(payDuration));
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId){
        var employee = employees[employeeId];
        totalSalary = totalSalary.add((salary * 1 ether));
        employees[employeeId]= Employee(employeeId,(salary * 1 ether),now);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
    }
    
    //update the salary of one employee
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = (totalSalary.add(salary * 1 ether)).sub(employee.salary);
        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayday = now;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunaway() returns (uint){
        return this.balance/totalSalary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunaway()>0;
    }

    //a employee get the salary of one single duration
    function getPaid() employeeExist(msg.sender){
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
    //get the basic info of an employee
    function checkEmployee(address employeeId) employeeExist(employeeId) returns(uint salary, uint lastPayday){
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function changePaymentAddress(address oldEmployeeId, address newEmployeeId) onlyOwner employeeExist(oldEmployeeId){
        var oldEmployee = employees[oldEmployeeId];
        _partialPaid(oldEmployee);
        employees[newEmployeeId] = Employee(newEmployeeId,oldEmployee.salary,oldEmployee.lastPayday);
        delete employees[oldEmployeeId];
    }
    
}
