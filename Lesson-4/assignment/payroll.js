var Payroll = artifacts.require("./Payroll.sol");

contract('PayrollTEST', function(accounts){

    it("Should not add an employee with negative salary:", function() {
        return Payroll.deployed().then(function(instance) {
             payrollInstance = instance;
            console.log("---addEmployee(accounts[1],-2 ether)---");
            return payrollInstance.addEmployee(accounts[1], -2);
        }).then(function() {
            return payrollInstance.employees.call(accounts[1]);
        }).catch(function(error) {
            assert.include(error.toString(), "invalid opcode", "Fail");
        });
    });

    it("Should add an employee:", function() {
        return Payroll.deployed().then(function(instance) {
             payrollInstance = instance;
            console.log("---addEmployee(accounts[1],2 ether)---");
            return payrollInstance.addEmployee(accounts[1], 2);
        }).then(function() {
            return payrollInstance.employees.call(accounts[1]);
        }).then(function(employee) {
            assert.equal(employee[0], accounts[1], "address mismatch, failed");
            assert.equal(web3.fromWei(employee[1].toNumber(),'ether'), 2, "salary mismatch, failed");
        });
      });
    
    it("Should not add an existing employee:", function() {
        return Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            console.log("---addEmployee(accounts[1],2 ether)---");
            return payrollInstance.addEmployee(accounts[1], 2);
        }).catch(function(error) {
            assert.include(error.toString(), "invalid opcode", "Fail");
        });
            //try to use the method below but failed? 
            /*
            assert.throws(
                function() {
                    return payrollInstance.addEmployee(accounts[1], 2);
                },
                "add existing employee failed";
            );
            */

      });

    it("Should not add employee by an adress instead of owner:", function() {
        return Payroll.deployed().then(function(instance) {
          payrollInstance = instance;
          console.log("---addEmployee(accounts[2],2 ether), from accounts[3]---");
          return payrollInstance.addEmployee(accounts[2], 1, {from: accounts[1]});
        }).catch(function(error) {
            assert.include(error.toString(), "invalid opcode", "Fail");
        });
      });

    it("Should not remove an employee by an adress instead of owner:", function() {
        return Payroll.deployed().then(function(instance) {
          payrollInstance = instance;
          console.log("---removeEmployee(accounts[1]), from accounts[3]---");
          return payrollInstance.removeEmployee(accounts[1], {from: accounts[1]});
        }).catch(function(error){
            assert.include(error.toString(), "invalid opcode", "Fail");
        });
    });

    it("Should remove an existing employee:", function() {
        return Payroll.deployed().then(function(instance) {
          payrollInstance = instance;
          payrollInstance.addFund({from: accounts[0],value:web3.toWei('10', 'ether')});
          console.log("---removeEmployee(accounts[1])---");
          return payrollInstance.removeEmployee(accounts[1]);
        }).then(function() {
          return payrollInstance.employees.call(accounts[1]);
        }).then(function(employee) {
          assert.equal(employee[0], 0x0, "address mismatch, failed");
        });
    });
    
    it("Should not remove an employee not existing:", function() {
        return Payroll.deployed().then(function(instance) {
          payrollInstance = instance;
          console.log("---removeEmployee(accounts[1]), which is not existing now---");
          return payrollInstance.removeEmployee(accounts[1]);
        }).catch(function(error){
            assert.include(error.toString(), "invalid opcode", "Fail");
        });
    });
  
    });
