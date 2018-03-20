/*优化之后的代码*/
pragma solidity ^0.4.14;
contract Payroll {
    //struct of one employee
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    address owner = msg.sender;
    Employee[] employees;   //arraylist of all employees, index starts from 0
    uint totalSalary = 0;
    
    uint constant payDuration = 10 seconds;
    
    //find the Id in all employees, return the instance and its index in the list
    //return null if not exist
    function _findEmployee(address employeId) private returns(Employee, uint){
        for(uint i=0;i<employees.length;i++){
            if(employees[i].id==employeId){
                return (employees[i],i);
            }
        }
    }
    
    //clear the unpaid salary
    function _partialPaid(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var(employee ,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0); //null result of _findEmployee, no same employee
        totalSalary += (salary * 1 ether);
        employees.push(Employee(employeeId,(salary * 1 ether),now));
    }
    
    function removeEmployee(address employeeId){
        require(msg.sender == owner && employees.length>0);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0); //employeeId exist in the employee list
        _partialPaid(employee);
        totalSalary -= employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
    }
    
    //update the salary of one employee
    function updateEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0); //employeeId exist in the employee list
        _partialPaid(employee);
        totalSalary += (salary - employee.salary);
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
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
    function getPaid(){
        var(employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }

}
