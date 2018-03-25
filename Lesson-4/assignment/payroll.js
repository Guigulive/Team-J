var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {


  it("Tset add employee:", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      console.log("---Run function addEmployee(accounts[0],1 ether).");
      return payrollInstance.addEmployee(accounts[1], 1);
    }).then(function() {
      
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee) {
      assert.equal(employee[0], accounts[1], "The address does not match.");
      assert.equal(web3.fromWei(employee[1].toNumber(),'ether'), 1, "The salary does not match.");
      console.log("---Run function addEmployee  succeed!");
    });
  });

  it("Tset remove employee:", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      payrollInstance.addFund({from: accounts[0],value:web3.toWei('50', 'ether')});
      console.log("---Run function removeEmployee(accounts[1]).");
      return payrollInstance.removeEmployee(accounts[1]);
    }).then(function() {
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee) {
      assert.equal(employee[0], 0x0, "The address does not match.");
      console.log("---Run function removeEmployee  succeed!");
    });
  });
});
