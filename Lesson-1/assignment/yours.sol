/**
 * The contractName contract does this and that...
 * A simple contract designed for a single employee and employer company
 *
 */
pragma solidity ^0.4.14;
 
contract PayRolll {
	uint salary;
	address frank;
	address boss;
	uint constant payDuration = 10 seconds;
	uint lastPayDay = now;

	//init the address of boss
	//the address of boss must be initialized at first 
    function initBoss(address boss_address) {
        if(boss_address == 0x0) {
            revert();
        }
        
        boss = boss_address;
    }

    function getBossAddress () returns(address) {
    	return boss;
    }

    function bossPermission () returns(bool) {
    	if(boss == 0x0 || msg.sender != boss) {
    		return false;
    	}

    	return true;
    }

    function initFrank(address frank_address) {
    	if(!bossPermission()) {
	    	revert();
	    }

        if(frank_address == 0x0) {
            revert();
        }
        
        frank = frank_address;
    }

	function updateAddress(address newAddress) {
		if(!bossPermission()) {
	    	revert();
	    }
	    
	    frank = newAddress;
	 }

	function getFrank() returns(address) {
	    return frank;
	}

	function frankPermission () returns(bool) {
		if(frank == 0x0 || msg.sender != frank) {
    		return false;
    	}

    	return true;
	}
	
    
    
    function initSalary (uint init_salary) {
    	if(!bossPermission()) {
	    	revert();
	    }

    	salary = init_salary * 1 ether;
    }

	function updateSalary(uint newSalary) {
		if(!bossPermission()) {
	    	revert();
	    }

	    salary = newSalary;
	}
	
	function getSalary() returns(uint) {
	    return salary;
	}
	    
	function addFund () payable returns (uint) {
	    if(!bossPermission()) {
	    	revert();
	    }
	    
		return this.balance;
	}

	function calculateRunway () returns(uint) {
		return this.balance / salary;
	}

	function hasEnoughFund () returns(bool) {
		return calculateRunway() > 0;
	}

	function getPaid () {
		if(!frankPermission()) {
			revert();
		}
		
		uint nextPayDay = lastPayDay + payDuration;
		if (nextPayDay > now) {
			revert();
		}

		lastPayDay = nextPayDay;
		frank.transfer(salary);
	}
}
