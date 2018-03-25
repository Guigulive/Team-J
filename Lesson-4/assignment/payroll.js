var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll',function(accounts){
    
    it("AddEmployee Test...",function(){
        return Payroll.deployed().then(function(instance){
            payrollInstance = instance;
            return payrollInstance.addEmployee(accounts[1],1);
        }).then(function(){
            return payrollInstance.employees.call(accounts[1]);
        }).then(function(employee){
            assert.equal(employee[0],accounts[1],"The address is wrong!");
            assert.equal(web3.fromWei(employee[1].toNumber(),'ether'),1,"The salary is wrong!");
        });
    });

    
    it("Remove Employee Test...",function(){
        return Payroll.deployed().then(function(instance){
            payrollInstance = instance;
            payrollInstance.addFund({from:accounts[0],value:web3.toWei('10000','ether')}); //删除员工前，增加一定数量的余额
            return payrollInstance.removeEmployee(accounts[1]);
        }).then(function(){
            return payrollInstance.employees.call(accounts[1]);
        }).then(function(employee){
            assert.equal(employee[0],0x0,"The address is wrong!");
        });
    });

});
   
