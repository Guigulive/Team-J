var Payroll = artifacts.require("./Payroll.sol");
var salary = 0;

contract('Payroll', function(accounts) {

  it("...should add a employee.", function() {
    return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        //payrollInstance.addFund({value:100});
        
      return payrollInstance.addEmployee('0xee2f23e959dd77f87c528fbdd2bd2c2ea81a405e', 1);
    
    }).then(function(balance) {
      salary = payrollInstance.checkEmployee('0xee2f23e959dd77f87c528fbdd2bd2c2ea81a405e').salary;
      assert.equal(salary, 1, "salary was not stored.");
    });
  });

  it("...should remove a employee.", function() {
    return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;

      return payrollInstance.removeEmployee('0xee2f23e959dd77f87c528fbdd2bd2c2ea81a405e');
    
    }).then(function(balance) {
      salary = payrollInstance.checkEmployee('0xee2f23e959dd77f87c528fbdd2bd2c2ea81a405e').salary;
      assert.equal(salary, 0, "employee was not removed.");
    });
  });

});
