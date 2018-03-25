var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
	var len = accounts.length;
	var index = Math.floor(Math.random()*len + 1);
	console.log("Add No." + index + " account");
	var salary = 1;
	

	it ("Add employee.", function() {
		return Payroll.deployed().then(function(instance) {
			payrollInstance = instance;

			return payrollInstance.addEmployee(accounts[index], salary);
		}).then(function() {
			return payrollInstance.employees.call(accounts[index]);
		}).then(function(employee) {
			assert.equal(employee[1].valueOf(), web3.toWei(salary) , "Adding the employee failed");
		});
	})

	it ("Remove employee", function() {
		return Payroll.deployed().then(function(instance) {
			payrollInstance = instance;
			return payrollInstance.removeEmployee(accounts[index]);
		}).then(function() {
			return payrollInstance.employees.call(accounts[index]);
		}).then(function(employee) {
			assert.equal(employee[0].valueOf(), 0x0 , "Deleting the employee failed");
		});
	})

});