var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll-addEmployee', function(accounts) {

  it("Should add an employee succesfully", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1], 1)
    }).then(function() {
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee) {
      assert.equal(employee[1].toNumber(), web3.toWei(1), "Fail");
    });
  });

  it("Shouldn't add an existing employee", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1], 1);
    }).then(function(){
      assert(false, "Fail to add");
    }).catch(function(error) {
      assert.include(error.toString(), "invalid opcode", "Fail");
    });
  });

  it("Shouldn't add employee from non owner", function() {
      return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addEmployee(accounts[3], 1, {from: accounts[1]});
      }).then(function(){
         assert(false, "Fail to add");
      }).catch(function(error) {
         assert.include(error.toString(), "revert", "Fail");
      });
    });
});


contract('Payroll-removeEmployee', function(accounts) {

  it("Should remove an employee succesfully", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1], 1)
    }).then(function() {
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee) {
      assert.equal(employee[1].toNumber(), web3.toWei(1), "Fail");
    }).then(function() {
      return payrollInstance.removeEmployee(accounts[1]);
    }).then(function(){
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee){
      assert.equal(employee[1].toNumber(), 0, "Fail");
    });
  });

    it("Shouldn't remove a non-existing employee", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.removeEmployee(accounts[1]);
    }).then(function(){
      assert(false, "Fail to remove");
    }).catch(function(error){
      assert.include(error.toString(), "invalid opcode", "Fail");
    });
  });


  it("Shouldn't remove an employee from non-owner", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1], 1)
    }).then(function() {
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee) {
      assert.equal(employee[1].toNumber(), web3.toWei(1), "Fail");
    }).then(function() {
      return payrollInstance.removeEmployee(accounts[1], {from: accounts[2]});
    }).then(function(){
      assert(false, "Fail to remove");
    }).catch(function(error){
      assert.include(error.toString(), "revert", "Fail");
    });
  });




});

