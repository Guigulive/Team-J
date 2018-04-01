 import React,{Component} from 'react'
 import {Table,Button,Modal,Form,InputNumber,Input,message,Popconfirm} from 'antd'
 
 import EditableCell from './EditableCell'
 
 const FormItem = Form.Item
 const columns = [
     {title:'地址',dataIndex:'address',key:'address'},
     {title:'账户余额',dataIndex:'balance',key:'balance'},
     {title:'工资',dataIndex:'salary',key:'salary'},
     {title:'上次支付',dataIndex:'lastPaidDay',key:'lastPaidDay'},
     {title:'操作',dataIndex:'',key:'action'}
 ]
 
 class EmployeeList extends Component {
     constructor(props){
         super(props)
         this.state = {
             loading:true,
             employees:[],
             employeestmp:[],
             showModel:false
         }
        
         columns[2].render = (text,record) => {
             return <EditableCell value={text}  onChange={this.updateEmployee.bind(this,record.address)} />
         }
 
         columns[4].render = (text,record) => {
             return(
                 <div>
                     <Popconfirm title="你确定要删除这个员工吗?" onConfirm={() => this.removeEmployee(record.address)} >
                         <a href="#">删除</a>
                     </Popconfirm>
                     <Button type="primary" onClick={() => this.props.onChangeRole("employee",record.address)} >详情</Button>
                 </div>
             )
         }
 
     }
 
     componentDidMount(){
         const {payroll,account} = this.props
 
         payroll.getInfo.call({from:account}).then((result) =>{
             const employeeCount = result[2].toNumber();
             if (employeeCount === 0){
                 this.setState({loading:false})
                 return
             }
 
             this.loadEmployees(employeeCount)
         })
 
     }
 
     loadEmployees(employeeCount){
         const {payroll,account,web3} = this.props
         const requests = []
 
         for (let index=0;index < employeeCount; index  ){
             requests.push(payroll.checkEmployee.call(index,{from:account}))
         }
 
 
 
         Promise.all(requests).then((values) => {
             // console.log("这里A")
 
             var employees = values.map((value,index) =>({
                 key:value[0],
                 address:value[0],
                 salary:web3.fromWei(value[1].toNumber()),
                 lastPaidDay:new Date(value[2].toNumber() * 1000).toString(),
                 // balance:"100"
                 // getbalance:web3.eth.getBalance(value[0],(err,result) =>{ 
                 //     return Promise.resolve(employees[index].balance = web3.fromWei(result.toNumber()))
                 // })
             }))
 
             for (let index=0;index < employees.length; index  ){
                 const ad = employees[index].address
                 // console.log(ad)
                 web3.eth.getBalance(ad,(err,result) =>{ 
                     employees[index].balance = web3.fromWei(result.toNumber()) 
                     // console.log("这里B")
                     if  (index === employees.length -1) {
                         // console.log("这里C")
                         this.setState({
                             employees,
                             loading:false
                         })
                     }
 
                 }) 
     
             }
 
         })
 
     }
 
 
 
 
 
 
     addEmployee = () =>{
         const {payroll,account} = this.props
         const {address,salary,employees} = this.state
         // console.log(typeof(address),address)
         payroll.addEmployee(address,salary,{from:account,gas:1000000}).then(()=>{
             const newEmployee = {
                 address,salary,key:address,laspPaidDay:new Date().toString(),balance:0
             }
 
             this.setState({
                 address:'',
                 salary:'',
                 showModel:false,
                 employees:employees.concat([newEmployee])
             })
             message.success("添加员工成功!!!")
         })
     }
 
     updateEmployee = (address,salary) =>{
         const {payroll,account} = this.props
         const {employees} = this.state
         payroll.updateEmployee(address,salary,{from:account,gas:1000000}).then(()=>{
 
             this.setState({
                 employees:employees.map((employee) =>{
                     if (employee.address === address){
                         employee.salary = salary
                     }
 
                     return employee
                 })
             })
             message.success("添加更新员工工资!!!")
         }).catch(()=>{
             message.error("合约里的足够的余额来更新员工信息!!!")
         })
     }
 
 
     removeEmployee = (employeeId) =>{
         const {payroll,account} = this.props
         const {employees} = this.state
         payroll.removeEmployee(employeeId,{from:account,gas:1000000}).then(()=>{
             this.setState({
                 employees:employees.filter(employee => employee.address !== employeeId)
             })
             message.success("已成功删除员工!!!")
         }).catch(()=>{
             message.error("合约里的足够的余额删除员工!!!")
         })
     }
 
     renderModel(){
         return(
             <Modal title="增加员工" visible={this.state.showModel} onOk={this.addEmployee} onCancel={()=>this.setState({showModel:false})}>
                 <Form>
                     <FormItem label="账户">
                         <Input onChange={ev => {
                             this.setState({address:ev.target.value})
                             // console.log(this.state.address)
                         }} />
                     </FormItem>
                     <FormItem label="工资">
                         <InputNumber min={1} onChange={salary => this.setState({salary})} />
                     </FormItem>
                 </Form>
             </Modal>
         )
     }
 
     render(){
         const {loading,employees} = this.state
         return(
             <div>
                 <Button type="primary" onClick={()=>this.setState({showModel:true})}>增加员工</Button>
                 {this.renderModel()}
                 <Table loading={loading} dataSource={employees} columns={columns} />
             </div>
         )
     }
 
 }
 
 export default EmployeeList 