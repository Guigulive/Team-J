pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Payroll.sol";

contract TestPayroll is Payroll {

    address employeeId = 0x308d0facd3dce0b531d7ddd19d15b58595dcbe20;

    // 测试添加一个员工
    function testAddEmployee() {
        addEmployee(employeeId, 2);
        var employee = employees[employeeId];
        Assert.equal(employee.id, employeeId, "can't stored.");
    }

    // 测试删除一个员工
    function testRemoveEmployee() {
        removeEmployee(employeeId);
        var employee = employees[employeeId];
        Assert.equal(employee.id, 0x0, "can't removed.");
    }

    // 测试领取工资
    // function testGetpaid() {
    //     getPaid();
    // }

}
