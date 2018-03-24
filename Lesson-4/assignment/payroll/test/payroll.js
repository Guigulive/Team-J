var payroll = artifacts.require("../payroll.sol");

contract('payroll', function (accounts) {
    // 测试用例，增加一个雇员，获取雇员比较地址是否相等
    it("successfully add employee", function () {
        return payroll.deployed().then(function (instance) {
            amount = web3.toWei(1, 'ether');
            newEmployee = accounts[1];
            salary = web3.toWei(1, 'ether');
            return instance.addFund({ from: accounts[2], value: amount })
                .then(function () {
                    return instance.addEmployee(newEmployee, salary)
                        .then(function () {
                            return instance.employees.call(accounts[1]);
                        })
                        .then(function(employees){
                            theEmployee = employees[0];
                            return theEmployee;
                        })
                        .then(function(employee){
                            assert.equal(newEmployee,employee,"add employee fail!");
                        });
                })
        })
    })

    it("successfully remove employee", function () {
        return payroll.deployed().then(function (instance) {
            amount = web3.toWei(1, 'ether');
            newEmployee = accounts[1];
            salary = web3.toWei(1, 'ether');

            return instance.addFund({ from: accounts[2], value: amount })
                .then(function () {
                    return instance.addEmployee(newEmployee, salary)
                        .then(function(){
                            return instance.removeEmployee(accounts[1]);
                        })
                        .then(function(){
                            return instance.employees.call(accounts[1]);
                        })
                        .then(function(employees){
                            assert(employees[0],0x0,"remove employee fail!");
                        })
                })
        })
    })
});
