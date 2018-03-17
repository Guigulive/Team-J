## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
---
GAS的消耗情况:
	Transaction Cost	Execution Cost
1	22971 gas	1699 gas
2	23759 gas	2487 gas
3	24547 gas	3275 gas
4	25335 gas	4063 gas
5	26123 gas	4851 gas
6	26911 gas	5639 gas
7	27699 gas	6427 gas
8	28487 gas	7215 gas
9	29275 gas	8003 gas
10	30063 gas	8791 gas

每次添加新员工后，消耗的gas增加，因为for循环执行次数增加


- 如何优化calculateRunway这个函数来减少gas的消耗？
---
用一个全局变量来记录总的salary，不用调用函数时每次计算
固定的gas消耗：
 transaction cost 	22122 gas 
 execution cost 	850 gas 

