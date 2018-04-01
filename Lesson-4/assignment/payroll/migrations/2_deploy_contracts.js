var ownable = artifacts.require("./Ownable.sol");
var safemath = artifacts.require("./SafeMath.sol");
var payroll = artifacts.require("./payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(ownable);
  deployer.deploy(safemath);
  deployer.link(ownable, payroll);
  deployer.link(safemath, payroll);
  deployer.deploy(payroll);
};
