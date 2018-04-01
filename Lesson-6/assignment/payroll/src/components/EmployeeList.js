import React from 'react'
import { Table, Button, Modal, Form, InputNumber, Input, message, Popconfirm } from 'antd'
import EditableCell from './EditableCell'

import moment from 'moment'

const FormItem = Form.Item

const columns = [{
    title: '地址',
    dataIndex: 'address',
    key: 'address'
},{
    title: '薪水',
    dataIndex: 'salary',
    key: 'salary'
},{
    title: '上次支付',
    dataIndex: 'lastPaidDay',
    key: 'lastPaidDay'
},{
    title: '操作',
    dataIndex: '',
    key: 'action'
}]

class EmployeeList extends React.Component {

    constructor(props) {
        super(props)

        this.state = {
            loading: true,
            employees: [],
            showModal: false,
            address: 0x0,
            salary: 0,
        }

        columns[1].render = (text, record) => (
            <EditableCell 
                value={text}
                onChange={ this.updateEmployee.bind(this, record.address) } />
        )

        columns[3].render = (text, record) => {
            return <Popconfirm title="你确定删除吗？" okText="确认" cancelText="取消" onConfirm={ this.removeEmployee.bind(this, record.address) }>
                <a href="#">删除</a>
            </Popconfirm>
        }
    }

    componentDidMount() {
        const { payroll, account } = this.props
        payroll.getInfo.call({
            from: account
        }).then((result) => {
            const employeeCount = result[2].toNumber()
            if (employeeCount == 0) {
                this.setState({loading: false})
                return
            }
            this.loadEmployees(employeeCount)
        })
    }

    loadEmployees(employeeCount) {
        const { web3, payroll, account } = this.props
        
        const requests = []
        for (let index = 0; index < employeeCount; index++) {
            requests.push(payroll.getEmployeeInfo.call(index, {
                from: account
            }))
        }

        Promise.all(requests).then((values) => {
            const employees = values.map(value => ({
                key: value[0],
                address: value[0],
                salary: web3.fromWei(value[1].toNumber()),
                lastPaidDay: moment(new Date(value[2].toNumber() * 1000)).format('YYYY-MM-DD HH:mm:ss')
            }))

            this.setState({
                employees,
                loading: false
            })
        })

    }

    // 添加员工
    addEmployee = () => {
        const { payroll, account } = this.props
        const { address, salary, employees } = this.state
        payroll.addEmployee(address, salary, {
            from: account,
            gas: 1000000
        }).then((result) => {
            message.info('添加员工成功');
            const newEmployee = {
                address,
                salary,
                key: address,
                lastPaidDay: moment(new Date()).format('YYYY-MM-DD HH:mm:ss')
            }
            this.setState({
                address: 0x0,
                salary: 0,
                showModal: false,
                employees: employees.concat([newEmployee])
            })
        }).catch((err) => {
            console.error(err)
            message.error('添加员工失败');
        })
    }

    // 更新员工
    updateEmployee = (address, salary) => {
        const { payroll, account } = this.props
        const { employees } = this.state
        payroll.updateEmployee(address, salary, {
            from: account,
            gas: 1000000
        }).then((result) => {
            this.setState({
                employees: employees.map((employee) => {
                    if (employee.address === address) {
                        employee.salary = salary
                    }
                    return employee
                })
            })
            message.info('更新成功');
        }).catch((err) => {
            console.error(err)
            message.error('你没有足够的余额支付员工薪酬');
        })
    }

    // 删除员工
    removeEmployee = (employeeId) => {
        const { payroll, account } = this.props
        const { employees } = this.state
        payroll.removeEmployee(employeeId, {
            from: account,
            gas: 1000000
        }).then((result) => {
            this.setState({
                employees: employees.filter(employee => employee.address != employeeId)
            })
            message.info("删除成功")
        }).catch((err) => {
            console.error(err)
            message.error('你没有足够的余额支付员工薪酬');
        })
    }

    renderModal() {
        return (
            <Modal title="增加员工" 
                visible={this.state.showModal} 
                okText="确认"
                cancelText="取消"
                onOk={this.addEmployee}
                onCancel={() => this.setState({showModal: false})}>
                <Form>
                    <FormItem label="地址">
                        <Input onChange={ event => this.setState({address: event.target.value})} />
                    </FormItem>
                    <FormItem label="薪水">
                        <InputNumber min={1} onChange={ salary => this.setState({ salary })} />
                    </FormItem>
                </Form>
            </Modal>
        )
    }

    render() {
        const { loading, employees } = this.state
        return (
            <div>
                <Button type="primary" onClick={() => this.setState({showModal: true})}>
                    添加员工
                </Button>
                { this.renderModal() }
                <Table loading={ loading } dataSource={employees} columns={columns} />
            </div>
        )
    }
}

export default EmployeeList