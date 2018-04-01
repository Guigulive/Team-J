//test/payroll.js, Truffle uses Mocha test frame to test automatically and uses Chai to assert. Truffle can only execute .js, ,es, .es6, .jsx
var PayRoll = artifacts.require("./Payroll.sol"); //artifacts.require() is a method to state dependencies. Here using it to import an
// solidity file
contract('PayRoll', function(account){ // 'PayRoll' is only for showing, which reminds people is about PayRoll.
  //add
  it("add employee", function(){
  //get a reference to the deployed PayRoll contract, as a JS object.
      // in case we can use this in interaction with contract in test, front-end, migration.
      return PayRoll.deployed().then(function(instance){
          payrollInstance = instance;
      }).then(function(){
          return payrollInstance.addFund(value: web3.toWei(100));
      )}.then(function(){
          return payrollInstance.addEmployee(accounts[1], 1);
      }).then(function(){
          return payrollinstance.employees.call(accounts[1]);
      }).then(function(employee){
          assert.equal(employee[1].valueOf(), web3.toWei(1), "F");
      });
    });
  //remove
  it("remove employee", function(){
      return PayRoll.deployed().then(function(instance){
          payrollInstance = instance;  
      }).then(function(){
          return payrollInstance.removeEmployee(accounts[1]);
      }).then(function(employee){
          assert.equal(employee[0].valueOf(), 0x0, "F")
      })
  });
});