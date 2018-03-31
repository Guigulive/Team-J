import React from 'react'
import Moment from 'moment'

import { Card, Col, Row, Layout, Alert, message, Button } from 'antd'

import Common from './Common'

class Employee extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            balance: 0,
            salary: 0,
            lastPaidDate: ''
        }
    }

    componentDidMount() {
        const { payroll } = this.props
        const reloadEmployeeInfo = (error, result) => {
            if (!error) {
                this.getEmployeeInfo()        
            }
        }

        this.getPaidEvent = payroll.GetPaid(reloadEmployeeInfo)

        this.getEmployeeInfo()
    }

    componentWillUnmount() {
        this.getPaidEvent.stopWatching()
    }

    getEmployeeInfo() {
        const { web3, payroll, account } = this.props
        payroll.employees.call(account, {
            from: account,
            gas: 1000000
        }).then((result) => {
            this.setState({
                salary: web3.fromWei(result[1].toNumber()),
                lastPaidDate: Moment(new Date(result[2].toNumber() * 1000)).format('YYYY-MM-DD HH:mm:ss')
            })
        }).catch((err) => {
            message.error('获取员工信息失败')
        })

        // 获取帐户余额
        web3.eth.getBalance(account, (err, result) => {
            if (!err) {
                this.setState({
                    balance: web3.fromWei(result.toNumber())
                })
            }
        })
    }

    getPaid() {
        const { payroll, account } = this.props
        payroll.getPaid({
            from: account,
            gas: 1000000
        }).then((result) => {
            message.info('领取薪水成功')
        }).catch((err) => {
            console.error('领取薪水失败',err)
            message.error('领取薪水失败')
        })
    }

    renderContent() {
        const { balance, salary, lastPaidDate } = this.state
        if (!salary || salary === '0') {
            return <Alert message="你不是员工" type="error" showIcon />
        }

        return (
            <div>
                <Row gutter={16}>
                    <Col span={8}>
                        <Card title="薪水">{ salary } Ether</Card>
                    </Col>
                    <Col span={8}>
                        <Card title="上次支付">{ lastPaidDate }</Card>
                    </Col>
                    <Col span={8}>
                        <Card title="帐号余额">{ balance } Ether</Card>
                    </Col>
                </Row>

                <Row style={{marginTop: '10px'}}>
                    <Col span={24}>
                        <Button type="primary" icon="bank" onClick={this.getPaid.bind(this)}>
                        获取酬劳
                        </Button>
                    </Col>
                </Row>
            </div>
        )
    }

    render() {
        const { account, payroll, web3 } = this.props

        return (
            <Layout style={{ padding: '0 24px', background: '#fff'}}>
                <Common account={ account } payroll={ payroll } web3={ web3 } />
                <h2>个人信息</h2>
                { this.renderContent() }
            </Layout>
        )
    }
}

export default Employee