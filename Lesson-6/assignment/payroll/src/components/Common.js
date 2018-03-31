import React from 'react'
import { Card, Col, Row } from 'antd'

class Common extends React.Component {
    constructor(props) {
        super(props)

        this.state = {
            balance: 0,
            employeeCount: 0,
            runway: 0
        }
    }

    componentDidMount() {
        const { payroll } = this.props
        const reloadInfo = (error, result) => {
            if (!error) {
                this.getInfo()
            }
        }

        this.newEmployeeEvent = payroll.NewEmployee(reloadInfo)
        this.removeEmployeeEvent = payroll.RemoveEmployee(reloadInfo)
        this.updateEmployeeEvent = payroll.UpdateEmployee(reloadInfo)
        this.getPaidEvent = payroll.GetPaid(reloadInfo)
        this.newFundEvent = payroll.NewFund(reloadInfo)

        this.getInfo()
    }

    componentWillUnmount() {
        this.newEmployeeEvent.stopWatching()
        this.removeEmployeeEvent.stopWatching()
        this.updateEmployeeEvent.stopWatching()
        this.getPaidEvent.stopWatching()
        this.newFundEvent.stopWatching()
    }

    getInfo() {
        const { payroll, web3, account } = this.props
        payroll.getInfo.call({from: account}).then((result) => {
            this.setState({
                balance: web3.fromWei(result[0].toNumber()),
                runway: result[1].toNumber(),
                employeeCount: result[2].toNumber()
            })
        }).catch(console.warn.bind(console))
    }

    render() {
        const {balance, employeeCount, runway} = this.state
        return (
            <div>
                <h2>通用信息</h2>
                <Row gutter={16}>
                    <Col span={8}>
                        <Card title="合约金额">{ balance } Ether</Card>
                    </Col>
                    <Col span={8}>
                        <Card title="员工人数">{ employeeCount }</Card>
                    </Col>
                    <Col span={8}>
                        <Card title="可支付次数">{ runway }</Card>
                    </Col>
                </Row>
            </div>
        )
    }
}

export default Common