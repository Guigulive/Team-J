import React, {Component} from 'react'
import PayrollContract from '../build/contracts/Payroll.json'
import getWeb3 from './utils/getWeb3'

import { Layout, Menu, Spin, Alert } from 'antd'
const { Content, Header, Footer } = Layout

import Employer from './components/Employer'
import Employee from './components/Employee'

import './App.css'
import 'antd/dist/antd.css'

class App extends Component {
    constructor(props) {
        super(props)

        this.state = {
            web3: null,
            payroll: null,          // Payroll合约实例
            account: null,          // 当前选择的帐户地址
            mode: 'employer'
        }
    }

    componentWillMount() {
        getWeb3.then(results => {
            this.setState({web3: results.web3})
            this.instantiateContract()
        }).catch((err) => {
            console.error('Error finding web3.\n', err)
        })
    }

    instantiateContract() {
        const contract = require('truffle-contract')
        const payroll = contract(PayrollContract)
        payroll.setProvider(this.state.web3.currentProvider)
        // 获取合约实例
        payroll.deployed().then((instance) => {
            this.setState({ payroll: instance})
            console.log('get payroll contract success')
        }).catch((err) => {
            console.error('获取合约实例失败: ', err)
        })
        // 获取合约帐户列表
        this.state.web3.eth.getAccounts((error, accounts) => {
            this.setState({
                account: accounts[0]
            })
        })
    }

    onSelectTab = ({key}) => {
        this.setState({
            mode: key
        })
    }

    renderContent() {
        const { account, payroll, web3, mode } = this.state
        if (!payroll) {
            return <Spin tip="Loading..." />
        }

        switch(mode) {
            case 'employer':
                return <Employer account={account} payroll={payroll} web3={web3}></Employer>
            case 'employee':
                return <Employee account={account} payroll={payroll} web3={web3}></Employee>
            default:
                return <Alert message="请选择一个模式" type="info" showIcon />
        }

    }

    render() {
        return (
            <Layout>
                <Header className="header">
                    <div className="logo">杨信区块链员工薪酬系统</div>
                    <Menu
                        theme="dark"
                        mode="horizontal"
                        defaultSelectedKeys={['employer']}
                        style={{ lineHeight: '64px' }}
                        onSelect={this.onSelectTab}>
                        <Menu.Item key="employer">雇主</Menu.Item>
                        <Menu.Item key="employee">雇员</Menu.Item>
                    </Menu>
                </Header>
                <Content style={{ padding: '0 50px' }}>
                    <Layout style={{ padding: '24px 0', background: '#fff', minHeight: '540px'  }}>
                        { this.renderContent() }
                    </Layout>
                </Content>
                <Footer style={{ textAlign: 'center' }}>
                    Payroll @2018 杨信区块链员工薪酬系统
                </Footer>
            </Layout>
        );
    }
}

export default App