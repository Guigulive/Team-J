pragma solidity ^0.4.14;

contract Payroll{
	address employer;
	address employee; 
	uint salary = 1 ether; // 默认工资为 1 ether
	uint constant payDuration = 10 seconds; // 工资发放周期 （constant 修饰变量 会起作用）
	uint lastPayday = now; // 最近一次发工资的时间

	// 初始化雇主
	function Payroll(){
		employer = msg.sender;
	}

    /* 
     * 在智能合约上充钱，用来支付工资。 
     * 合约的balance不能直接接改，而是自动计算的
     * 调用带payable的函数时附带上value给合约打钱，合约的balance会自动变化
     */
	function addFund() payable returns (uint){
		return this.balance;
	}

    // 计算智能合约内的钱还可以支付多少次工资
	function calculateRunway() returns(uint){
		return this.balance / salary;
	}
    
    // 判断智能合约内的钱是否还可以支付工资
	function hasEnoughFund() returns (bool){
	    // 使用this来调用，会消耗很高的 gas
		return calculateRunway() > 0;
	}

    // 拿工资
	function getPaid(){
	    // 判断是否为指定调用者
		if (msg.sender != employee){
			revert();
		}

	    // 计算会消耗 gas，避免重复计算
		uint nextPayDay = lastPayday + payDuration;
		
		if (nextPayDay > now){
		    // 函数中局部变量会穿透花括号，作用于整个函数

		    // 使用revert可以回收剩余的 gas
			revert();
		}

		// 修改完内部变量后，再给外部钱。估摸着，调用transfer有可能因遭受攻击而失败。
		lastPayday = nextPayDay;
		employee.transfer(salary);
	}

	// 结清当前账务
	function payment() {
		if (msg.sender != employer){
			revert();
		}
        lastPayday = now;
        if (employee != 0x0) {
        	uint amount = salary * (now - lastPayday) / payDuration;
            employee.transfer(amount);
        }
	}

    // 更换雇员
    function setEmployee(address e)  returns (address)  {
        //payment();   
        employee = e;
        return employee;
    }

    // 调整工资，以 ether 为单位
	function setSalary(uint s)  returns (uint){
	    //payment();   
		salary = s * 1 ether;
		return salary;
	} 
}
