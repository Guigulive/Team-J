var Payroll = artifacts.require("./Payroll.sol");
var BigNumber = require('bignumber.js')

contract('Payroll', async (accounts) => {

    it("should store the balance 100 ether.", async () => {
        let instance = await Payroll.deployed()
        let fund = await web3.toWei(10, 'ether')
        let result = await instance.addFund({value: fund})
        let balance = await instance.getBalance()
        assert.isAtLeast(balance, fund, "the balance 10 ether not stored.")
    })

    it("add a employee.", async () => {
        let instance = await Payroll.deployed()
        await instance.addEmployee(accounts[1],2)
        let result = await instance.employees.call(accounts[1])
        let addressId = result[0]
        let salary = new BigNumber(result[1] / 1e18, 18).toNumber()
        let lastPayDay = new BigNumber(result[2]).toNumber()
        assert.equal(addressId, accounts[1], `${accounts[1]} can't stored.`)
        assert.equal(salary, 2, "salary can't equal")
    })

    it("remove a employee", async () => {
        let instance = await Payroll.deployed()
        await instance.removeEmployee(accounts[1])
        let result = await instance.employees.call(accounts[1])
        assert.equal(result[0], 0x0, `${accounts[1]} can't remove.`)
    })

    const sleep = (timeountMS) => new Promise((resolve) => {
        setTimeout(resolve, timeountMS);
    });

    it("employee get the salary.", async () => {
        let instance = await Payroll.deployed()
        // 加钱
        let fund = await web3.toWei(10, 'ether')
        await instance.addFund({value: fund})
        // 添加员工
        await instance.addEmployee(accounts[1], 2)
        let result = await instance.employees.call(accounts[1])
        assert.equal(result[0], accounts[1], "the employee can't store ")
        console.log('员工的薪水为：', result[1].toNumber() / 1e18 + ' ETH')
        let balance = await web3.eth.getBalance(accounts[1]).toNumber() / 1e18
        console.log(`${accounts[1]} 领取工资前的余额为：${balance} ETH`)
        // 10秒后领取领取工资
        await sleep(10 * 1000) 
        await instance.getPaid({from: accounts[1]})
        console.log('领取工资成功')
        let newBalance = await web3.eth.getBalance(accounts[1]).toNumber() / 1e18
        console.log(`${accounts[1]} 领取工资后的余额为：${newBalance} ETH`)
        assert.isAbove(newBalance,balance, "can't get salary")
    })
});
