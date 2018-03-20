pragma solidity ^0.4.14;
import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable{
    
    using SafeMath for uint8;
    // 
    uint totalSalary = 0 ;
    // 
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    
    uint constant payDuration = 10 seconds;
    // contract owner ,initialed first time and immutable further more
    address owner;
    
    mapping(address=> Employee) public employees;

    modifier employeeExist(address employeeId) {
        var employee= employees[employeeId];
        assert(employee.id !=0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment =  employee.salary * (now - employee.lastPayday)/ payDuration;
        employee.id.transfer(payment);
    }
    

    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id ==0x0);
        employees[employeeId] = Employee(employeeId,salary * 1 ether,now);
        // update totalSalary after add 
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        
        // update totalSalary after remove 
        totalSalary -= employees[employeeId].salary;
        
        delete employees[employeeId];
    }
    
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){
         var employee = employees[employeeId];
         _partialPaid(employee);
         // update totalSalary after update
         totalSalary += (salary - employees[employeeId].salary);
         
        employees[employeeId].salary = salary;
        employees[employeeId].lastPayday = now;
    }
    
    function changePaymentAddress(address oldEmployeeId,address newEmployeeId) onlyOwner employeeExist(oldEmployeeId){
         var oldEmployee = employees[oldEmployeeId];
         _partialPaid(oldEmployee);
         // finish cleanup for old employee address
         employees[newEmployeeId] = Employee(newEmployeeId,oldEmployee.salary,oldEmployee.lastPayday);
         delete employees[oldEmployeeId];
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() >0;
    }
    
    
    function getPaid() employeeExist(msg.sender){
        var employee = employees[msg.sender];
        assert(employee.id !=0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        
        assert(nextPayday<now);
        
        employees[msg.sender].lastPayday = nextPayday;
        
        employee.id.transfer(employee.salary);
    }
}

