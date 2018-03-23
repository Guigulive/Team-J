/*作业请提交在这个目录下*/
/**
 * The contractName contract does this and that...
 * A simple contract designed for a single employee and employer company
 *
 */

// DATA

// BEFORE

// employees 1
// transaction cost 23046 gas
// execution cost 1774 gas

// employees 2
// transaction cost 23827 gas
// execution cost 2555 gas

// employees 5
// transaction cost 24608 gas
// execution cost 3336 gas

// employees 10
// transaction cost 29294 gas
// execution cost 8022 gas

// AFTER

// employees 1
// transaction cost 22453 gas
// execution cost 1181 gas

// employees 2
// transaction cost 22453 gas
// execution cost 1181 gas

// employees 5
// transaction cost 22453 gas
// execution cost 1181 gas

// employees 10
// transaction cost 22453 gas
// execution cost 1181 gas

pragma solidity ^0.4.14;
 
contract PayRolll {

	struct Employee {
		address id;
		uint salary;
		uint lastPayDay;
	}
	address boss;
	uint constant payDuration = 10 seconds;
	Employee[] employees;
	uint totalSalaryCache = 0;

	function _partialPay (Employee employee) private {
		uint payment = employee.salary * (now - employee.lastPayDay) / payDuration;
		employee.id.transfer(payment);
	}

	function _findEmployee (address employeeId) private returns(Employee, uint) {
		for(uint i = 0; i < employees.length; i++) {
			if(employees[i].id == employeeId) {
				return (employees[i], i);
			}
		}
	}

	function _updateTotalSalaryCache(uint salary, bool add) private {
		if(add) {
			totalSalaryCache += salary; 
		} else {
			totalSalaryCache -= salary;
		}
	}
	
	
	function addEmployee (address employeeId, uint salary) {
		require (msg.sender == boss);
		var(employee, index) = _findEmployee(employeeId);
		assert (employee.id == 0x0);
		employees.push(Employee(employeeId, salary * 1 ether, now));
		_updateTotalSalaryCache(salary, true);
	}

	function removeEmployee (address employeeId) {
		require (msg.sender == boss);
		var(employee, index) = _findEmployee(employeeId);
		assert (employee.id != 0x0);
		_partialPay(employee);
		_updateTotalSalaryCache(employee.salary, false);
		delete employees[index];
		employees[index] = employees[employees.length - 1];
		employees.length -= 1;
		return;
	}

	function updateEmployee (address employeeId, uint salary) {
		require (msg.sender == boss);
		var(employee, index) = _findEmployee(employeeId);
		assert (employee.id != 0x0);
		_partialPay(employee);
		if(employee.salary < salary) {
			_updateTotalSalaryCache(salary - employee.salary, true);
		} else {
			_updateTotalSalaryCache(employee.salary - salary, false);
		}
		employees[index].salary = salary * 1 ether;
		employees[index].lastPayDay = now;
		return;
	}
	
	
	//init the address of boss
	//the address of boss must be initialized at first 
	function PayRolll () {
		boss = msg.sender;
	}

	function addFund () payable returns (uint) {
	    require (msg.sender == boss);
	    
		return this.balance;
	}

	function _calculateTotalSalary () private returns(uint) {
		uint totalSalary = 0;
		for(uint i = 0 ; i < employees.length; i++) {
			totalSalary += employees[i].salary;
		}

		return totalSalary;
	}
	

	function calculateRunway () returns(uint) {
		uint _totalSalary = _calculateTotalSalary();
		assert (_totalSalary != 0);
		return this.balance / _totalSalary;
	}

	function calculateRunwayWithCache() returns (uint) {
        uint _totalSalary;
        if(totalSalaryCache != 0){
            _totalSalary = totalSalaryCache;
        }else{
            _totalSalary = _calculateTotalSalary();
        }
        assert (_totalSalary != 0);
        return this.balance / _totalSalary;
    }
    

	function hasEnoughFund () returns(bool) {
		return calculateRunway() > 0;
	}

	function getPaid () {
		var(employee, index) = _findEmployee(msg.sender);
		assert (employee.id != 0x0);
		uint nextPayDay = employee.lastPayDay + payDuration;
		assert (nextPayDay < now);
		employee.lastPayDay = nextPayDay;
		employee.id.transfer(employee.salary);
	}
}
