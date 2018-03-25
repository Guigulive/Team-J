
	it ("Others cannot add employee.", function() {
		return Payroll.deployed().then(function(instance) {
			payrollInstance = instance;

			return payrollInstance.removeEmployee(accounts[index], salary, {from: accounts[other]});
		}).catch(function(err) {
			assert.include(error.toString(),"Error: VM Exception while processing transaction: revert","Warning! Employees can add employees")
		});
	})




	it ("Employees add employee.", function() {
		return Payroll.deployed().then(function(instance) {
			payrollInstance = instance;

			return payrollInstance.addEmployee(accounts[index], salary, {from: accounts[other]});
		}).catch(err => {
			exception = true;
		}).then(function(employee) {
			assert.equal(exception,true,"Warning! Employees can add employees");
		});
	})

	it ("Employees cannot remove add employee.", function() {
		return Payroll.deployed().then(function(instance) {
			payrollInstance = instance;

			return payrollInstance.removeEmployee(accounts[index], {from: accounts[other]});
		}).catch(err => {
			exception = true;
		}).then(function(employee) {
			assert.equal(exception,true,"Warning! Employees can remove other employees");
		});
	})

	it ("Cannot remove non_exist employee.", function() {
		return Payroll.deployed().then(function(instance) {
			payrollInstance = instance;

			return payrollInstance.removeEmployee(accounts[index], {from: accounts[other]});
		}).catch(err => {
			exception = true;
		}).then(function(employee) {
			assert.equal(exception,true,"Warning! Employees can remove other employees");
		});
	})
