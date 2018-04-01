/*作业请提交在这个目录下*/

pragma solidity ^0.4.14;
 
contract PayRolll {

	struct Employee {
		address id;
		uint salary;
		uint lastPayDay;
	}
	address boss;
	uint constant payDuration = 10 seconds;
	mapping (address => Employee) public employees;
	uint totalSalaryCache = 0;

	function PayRolll () {
		boss = msg.sender;
	}

	modifier onlyOnwer { 
		require (msg.sender == boss);
		_; //表示代码是加在代码开始的
	}

	modifier employeeExist(address employeeId) { 
		var employee = employees[employeeId];
		assert (employee.id != 0x0); 
		_; 
	}
	
	
	function _partialPay (Employee employee) private {
		uint payment = employee.salary * (now - employee.lastPayDay) / payDuration;
		employee.id.transfer(payment);
	}

	function addEmployee (address employeeId, uint salary) onlyOnwer {
        var employee = employees[employeeId];
		assert (employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
		totalSalaryCache += salary * 1 ether;
	}

	function removeEmployee (address employeeId) onlyOnwer employeeExist(employeeId) {
		var employee = employees[employeeId];
		_partialPay(employee);
		totalSalaryCache -= employee.salary * 1 ether;
		delete employees[employeeId];
		return;
	}

	function updateEmployee (address employeeId, uint salary) onlyOnwer employeeExist(employeeId) {
		var employee = employees[employeeId];
		_partialPay(employee);
		totalSalaryCache -= employee.salary;
		totalSalaryCache += salary;
		employees[employeeId].salary = salary * 1 ether;
		employees[employeeId].lastPayDay = now;
		return;
	}	

	function addFund () payable returns (uint) {	    
		return this.balance;
	}

	function calculateRunway () returns(uint) {
		assert (totalSalaryCache != 0);
		return this.balance / totalSalaryCache;
	}
    
	function hasEnoughFund () returns(bool) {
		return calculateRunway() > 0;
	}

	function getPaid () employeeExist(msg.sender) {
		var employee = employees[msg.sender];
		uint nextPayDay = employee.lastPayDay + payDuration;
		assert (nextPayDay < now);
		employees[msg.sender].lastPayDay = nextPayDay;
		employee.id.transfer(employee.salary);
	}

	function changePaymentAddress (address employeeId, address newAddress) onlyOnwer employeeExist(employeeId) {
		var employee = employees[employeeId];
		var salary = employee.salary;
		_partialPay(employee);
		delete employees[employeeId];
		employees[newAddress] = Employee(newAddress, salary * 1 ether, now);
		return;
	}
}
