pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;//
    uint salary;
    address employee;//
    uint lastPayday;

    function Payroll() {
        // 参数初始化
        owner = msg.sender;
        salary = 1 ether;
        employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;//
        lastPayday = now;
    }
    
    function getOwner() returns(uint){
        return this.balance;
    }
    
    function getEmployeeBalance() returns(uint){
        return employee.balance;
    }
    
    function updateEmployee(address e, uint s) {//改变员工的收款地址和薪资，只有合约部署者才能调用
        require(owner == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;//在改变地址之前，先把未提取的工资下发
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    /**
    修改员工薪资，单位ether
    */
    function updateEmployeeSalary(uint newSalary) {//改变员工薪资，只有合约部署者才能调用
        require(msg.sender == owner);
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;//在改变地址之前，先把未提取的工资下发
            employee.transfer(payment);
        }
        salary = newSalary * 10^18 wei;
    }
    
    /**
    修改员工地址
    */
    function updateEmployeeAddress(address newAddress) {//改变员工的收款地址和薪资，只有合约部署者才能调用
        require(msg.sender == owner);
        employee = newAddress;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() returns(uint){
        if(msg.sender != employee) {
            revert();
        }
      
        uint nextPayday = lastPayday + payDuration;
        if(nextPayday > now){
            revert();
        }

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
