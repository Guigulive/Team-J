/*作业请提交在这个目录下*/

/*作业请提交在这个目录下*/


//优化之前代码
pragma solidity ^0.4.14;
contract Payroll{
	//员工结构对象
    struct Employee{
        address addr;
        uint salary;
        uint lastPayday;
    }
    //合约的拥有者
    address owner;
    uint constant payDuration= 10 seconds;
    Employee[] Employees;

	function Payroll(){
	    owner=msg.sender;
	}

	//员工薪资支付
	function _partpaid(Employee employee) private{
	     uint mustPaySalary = employee.salary*(now-employee.lastPayday)/payDuration;
	     employee.addr.transfer(mustPaySalary);
	}
	//查找员工
	function _findEmployee(address employeeAddr) private returns(Employee,uint){
	    for(uint i=0;i<Employees.length;i++){
	        if(Employees[i].addr==employeeAddr){
	            return (Employees[i],i);
	        }
	    }
	}

	//增加一个雇员
	function addEmplyee(address employee) public{

	     require(msg.sender==owner);

	     var (employeeAddr,index)=_findEmployee(employee);

	     assert(employeeAddr.addr==0x0);

	     uint emplyeeSalary =  1 ether;

	     Employees.push(Employee(employee,emplyeeSalary,now));

	}
	//移除一个雇员
	function removeEmployee(address employee){
	    require(msg.sender==owner);
	    var (employeeAddr,index)=_findEmployee(employee);

	    assert(employeeAddr.addr!=0x0);

	    _partpaid(employeeAddr);

	    delete Employees[index];

	    Employees[index] = Employees[Employees.length-1];

	    Employees.length -=1;
	}



    //给合约增加金额
    function addFund() payable public returns(uint){
        return this.balance;
    }

	//可以支付薪水的次数
    function calculateRunway() public returns(uint){
        uint totalSalary;
         for(uint i=0;i<Employees.length;i++){

	             totalSalary +=Employees[i].salary;
	    }
        return this.balance/totalSalary;
    }

	//是否可以足够支付
    function hasEnoughFund() private returns(bool){
        return calculateRunway()>0;
    }

	//到时间就领取薪水
    function getPaid() public{

        var (employeeAddr,index)=_findEmployee(msg.sender);
        assert(employeeAddr.addr!=0x0);

        uint nextDay=employeeAddr.lastPayday+payDuration;
        assert(nextDay<now);

        Employees[index].lastPayday=nextDay;
        employeeAddr.addr.transfer(employeeAddr.salary);
    }

}


//--------------------------测试结果-------------------------------------

未优化的gas消耗情况，随着员工的增加，calculateRunway（）的gas也增加

id	添加雇员	                                 transaction cost 	execution cost
1	0x14723a09acff6d2a60dcdf7aa4aff308fddc160c	    22958 gas	        1686 gas
2	0xdd870fa1b7c4700f2bd7f44238821c26f7392142	    26863 gas	        5591 gas
3	0xdd870fa1b7c4700f2bd7f44238821c26f7392143	    27644 gas	        6372 gas
4	0xdd870fa1b7c4700f2bd7f44238821c26f7392144	    28425 gas	        7153 gas
5	0xdd870fa1b7c4700f2bd7f44238821c26f7392145	    29206 gas	        7934 gas
6	0xdd870fa1b7c4700f2bd7f44238821c26f7392146	    29987 gas	        8715 gas
7	0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db	    23739 gas	        2467 gas
8	0x583031d1113ad414f02576bd6afabfb302140225	    24520 gas	        3248 gas
9	0xdd870fa1b7c4700f2bd7f44238821c26f7392148	    25301 gas	        4029 gas
10	0xdd870fa1b7c4700f2bd7f44238821c26f7392141	    26082 gas	        4810 gas

优化后的gas消耗明显减少，并且保持不变：
id	添加雇员	                                  transaction cost 	execution cost
1	0x14723a09acff6d2a60dcdf7aa4aff308fddc160c	    22124 gas	        852 gas
2	0xdd870fa1b7c4700f2bd7f44238821c26f7392142	    22124 gas	        852 gas
3	0xdd870fa1b7c4700f2bd7f44238821c26f7392143	    22124 gas	        852 gas
4	0xdd870fa1b7c4700f2bd7f44238821c26f7392144	    22124 gas	        852 gas
5	0xdd870fa1b7c4700f2bd7f44238821c26f7392145	    22124 gas	        852 gas
6	0xdd870fa1b7c4700f2bd7f44238821c26f7392146	    22124 gas	        852 gas
7	0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db	    22124 gas	        852 gas
8	0x583031d1113ad414f02576bd6afabfb302140225	    22124 gas	        852 gas
9	0xdd870fa1b7c4700f2bd7f44238821c26f7392148	    22124 gas	        852 gas
10	0xdd870fa1b7c4700f2bd7f44238821c26f7392141	    22124 gas	        852 gas

//--------------------优化后的代码如下：

//--------------------优化后的代码如下：

//优化calculateRunway()函数后代码
pragma solidity ^0.4.14;
contract Payroll{
    //员工结构对象
    struct Employee{
        address addr;
        uint salary;
        uint lastPayday;
    }

    //合约的拥有者
    address owner;
    uint constant payDuration= 10 seconds;
    Employee[] Employees;
    uint totalSalary; //----------------->总需要支付的薪水和

	function Payroll(){
	    owner=msg.sender;
	}

	//员工薪资支付
	function _partpaid(Employee employee) private{
	     uint mustPaySalary = employee.salary*(now-employee.lastPayday)/payDuration;
	     employee.addr.transfer(mustPaySalary);
	}

	//查找某个员工
	function _findEmployee(address employeeAddr) private returns(Employee,uint){
	    for(uint i=0;i<Employees.length;i++){
	        if(Employees[i].addr==employeeAddr){
	            return (Employees[i],i);
	        }
	    }
	}

	//增加一个员工
	function addEmplyee(address employee) public{

	     require(msg.sender==owner);

	     var (employeeAddr,index)=_findEmployee(employee);

	     assert(employeeAddr.addr==0x0);

	     uint emplyeeSalary =  1 ether;

	     Employees.push(Employee(employee,emplyeeSalary,now));


		 //每次增加的时候 就计算好总薪资
	     totalSalary +=emplyeeSalary;

	}

	//移除一个员工
	function removeEmployee(address employee){
	    require(msg.sender==owner);
	    var (employeeAddr,index)=_findEmployee(employee);

	    assert(employeeAddr.addr!=0x0);

	    totalSalary -= employeeAddr.salary;

	    _partpaid(employeeAddr);

	    delete Employees[index];

	    Employees[index] = Employees[Employees.length-1];

	    Employees.length -=1;
	}



    //给合约增加金额
    function addFund() payable public returns(uint){
        return this.balance;
    }

	//可以支付薪水的次数
    function calculateRunway() public returns(uint){
       /* uint totalSalary;
         for(uint i=0;i<Employees.length;i++){

	             totalSalary +=Employees[i].salary;
	    }*/
        return this.balance/totalSalary;
    }

	//是否可以足够支付
    function hasEnoughFund() private returns(bool){
        return calculateRunway()>0;
    }

	//到时间就领取薪水
    function getPaid() public{

        var (employeeAddr,index)=_findEmployee(msg.sender);
        assert(employeeAddr.addr!=0x0);

        uint nextDay=employeeAddr.lastPayday+payDuration;
        assert(nextDay<now);

        Employees[index].lastPayday=nextDay;
        employeeAddr.addr.transfer(employeeAddr.salary);
    }
}
