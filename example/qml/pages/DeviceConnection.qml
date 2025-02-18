import QtQuick
import QtQuick.Controls
//import QtQuick.Layouts 1.15

import "../controls"

Item {
    implicitWidth: 720
    implicitHeight: 60
    //anchors.fill : parent

    Component.onCompleted:{
        deviceManager.startGetNewPort();
    }

    Connections {
        target: deviceManager
        function onUpdateComPortList(portlist) {
            //calibDevicePort.clearList()
            deltaxsRobotPort.clearList()
            //testDevicePort.clearList()
            for (var index = 0; index < portlist.length; index++)
            {
                //calibDevicePort.addElement(portlist[index])
                deltaxsRobotPort.addElement(portlist[index])
                //testDevicePort.addElement(portlist[index])
            }
        }

// connect robot device
        function onConnectDeltaXFeedback(portname, id) {
            if (portname === "" && id === ""){
                console.log("connect delta faild")
                set_robot_disconnected_state();
            }
            else
            {
                set_robot_connected_state(portname, id);
            }
        }

// connect calib device
        function onConnectCalibratorFeedback(portname, id) {
            if (portname === "" && id === ""){
                console.log("connect calib faild")
                set_calib_disconnected_state();
            }
            else
            {
                set_calib_connected_state(portname, id);
            }
        }

// connect test device
        function onConnectTestFeedback(portname, id) {
            if (portname === "" && id === ""){
                console.log("connect test faild")
                set_test_disconnected_state();
            }
            else
            {
                set_test_connected_state(portname, id);
            }
        }

// led calib signal
        function onRxCalibratorSignal(byte_count) {
            rxLedCalib.startBlinking(byte_count)
        }

        function onTxCalibratorSignal(byte_count) {
            txLedCalib.startBlinking(byte_count)
        }

// led deltax signal
        function onRxDeltaXSignal(byte_count) {
            rxLedRobot.startBlinking(byte_count)
        }

        function onTxDeltaXSignal(byte_count) {
            txLedRobot.startBlinking(byte_count)
        }

// led test signal
        function onRxTestSignal(byte_count) {
            rxLedTest.startBlinking(byte_count)
        }

        function onTxTestSignal(byte_count) {
            txLedTest.startBlinking(byte_count)
        }
    }

//robot state
    function set_robot_connected_state(portname, id){
        deltaxsRobotPort.setText(portname)
        deltaxsRobotID.setText(id)
        deltaxsRobotBtn.isActiveMenu = true
        deltaxsRobotPort.disableInput()
        //deltaxsRobotID.disabledInput()
    }

    function set_robot_disconnected_state(){
        deltaxsRobotBtn.isActiveMenu = false
        deltaxsRobotPort.enableInput()
        //deltaxsRobotID.enableInput()
    }

//calib state
//    function set_calib_connected_state(portname, id){
//        calibDevicePort.setText(portname)
//        calibDeviceID.setText(id)
//        calibDeviceBtn.isActiveMenu = true
//        calibDevicePort.disableInput()
//        //calibDeviceID.disabledInput()
//    }

//    function set_calib_disconnected_state(){
//        calibDeviceBtn.isActiveMenu = false
//        calibDevicePort.enableInput()
//        //calibDeviceID.enableInput()
//    }

//test state
//    function set_test_connected_state(portname, id){
//        testDevicePort.setText(portname)
//        testDeviceID.setText(id)
//        testDeviceBtn.isActiveMenu = true
//        testDevicePort.disableInput()
//        //testDeviceID.disabledInput()
//    }

//    function set_test_disconnected_state(){
//        testDeviceBtn.isActiveMenu = false
//        testDevicePort.enableInput()
//        //testDeviceID.enableInput()
//    }

    CustomMessageDialog {
        id: messageDialog
    }

    Rectangle {
        color: "#e6e6e6"
        anchors.fill: parent
        anchors.topMargin: 2
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.bottomMargin: 2
        radius: 6

        Row {
            anchors.fill: parent
            spacing: 4

//Calib Device
//            Rectangle {
//                id: rectangle
//                color: "transparent"
//                height: parent.height
//                width: (parent.width - 8) / 3
//                radius: 6
//                border.width: 1
//                border.color: "blue"

//                Label {
//                    id: calibDeviceLabel
//                    text: "Calibration Device"
//                    anchors.top: parent.top
//                    anchors.topMargin: 3
//                    font.bold: true
//                    font.pointSize: 10
//                    anchors.leftMargin: 10
//                    anchors.left: parent.left
//                }

//                LedBlinking {
//                    id: rxLedCalib
//                    anchors.verticalCenter: calibDeviceLabel.verticalCenter
//                    anchors.right: parent.right
//                    anchors.rightMargin: 20
//                }

//                LedBlinking {
//                    id: txLedCalib
//                    anchors.verticalCenter: calibDeviceLabel.verticalCenter
//                    anchors.right: parent.right
//                    on_color: "green"
//                    anchors.rightMargin: 60
//                }


//                LeftMenuButton {
//                    id: calibDeviceBtn
//                    anchors.left: parent.left
//                    anchors.bottom: parent.bottom
//                    anchors.bottomMargin: 3
//                    anchors.leftMargin: 4
//                    onClicked: {
//                        if (isActiveMenu == false) {
//                            deviceManager.connectCalibrator(calibDevicePort.getText(), calibDeviceID.getText())
//                            //console.log("port:" + deltaxsRobotPort.getText() + " id:" + deltaxsRobotID.getText())
//                        }
//                        else{
//                            deviceManager.disconnectCalibrator()
//                            set_calib_disconnected_state()
//                        }
//                    }
//                }

//                CustomComboBox {
//                    id: calibDevicePort
//                    anchors.verticalCenter: calibDeviceBtn.verticalCenter
//                    anchors.left: calibDeviceBtn.right
//                    anchors.right: calibDeviceID.left
//                    anchors.rightMargin: 12
//                    anchors.leftMargin: 12

//                }

//                CustomTextField {
//                    id: calibDeviceID
//                    anchors.verticalCenter: calibDeviceBtn.verticalCenter
//                    anchors.right: parent.right
//                    anchors.rightMargin: 4
//                    onTextEnter: {
//                        if (calibDeviceBtn.isActiveMenu == true){
//                            if (deviceManager.changeIdCalibrator(text)){
//                                messageDialog.showNote(true, "Changed Address")
//                            }
//                            else{
//                                messageDialog.showNote(false, "Device disconnected")
//                            }
//                        }
//                    }
//                }
//            }

//Delta X Robot
            Rectangle {
                color: "transparent"
                height: parent.height
                //width: (parent.width - 8) / 3
                width: (parent.width > 400)?400:parent.width
                radius: 6
                border.width: 1
                border.color: "blue"

                Label {
                    id: deltaxsRobotLabel
                    text: "DeltaX S Robot"
                    anchors.top: parent.top
                    anchors.topMargin: 3
                    font.bold: true
                    font.pointSize: 12
                    anchors.leftMargin: 10
                    anchors.left: parent.left
                }

                LedBlinking {
                    id: rxLedRobot
                    anchors.verticalCenter: deltaxsRobotLabel.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                }

                LedBlinking {
                    id: txLedRobot
                    anchors.verticalCenter: deltaxsRobotLabel.verticalCenter
                    anchors.right: parent.right
                    on_color: "green"
                    anchors.rightMargin: 60
                }

                LeftMenuButton {
                    id: deltaxsRobotBtn
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                    anchors.leftMargin: 4
                    height: 42
                    onClicked: {
                        if (isActiveMenu == false) {
                            deviceManager.connectDeltaXRobot(deltaxsRobotPort.getText(), deltaxsRobotID.getText())
                            //console.log("port:" + deltaxsRobotPort.getText() + " id:" + deltaxsRobotID.getText());
                        }
                        else{
                            deviceManager.disconnectDeltaXRobot()
                            set_robot_disconnected_state();
                        }
                    }
                }

                CustomComboBox {
                    id: deltaxsRobotPort
                    anchors.verticalCenter: deltaxsRobotBtn.verticalCenter
                    anchors.left: deltaxsRobotBtn.right
                    anchors.right: deltaxsRobotID.left
                    anchors.rightMargin: 12
                    anchors.leftMargin: 40
                    height: 40
                }

                CustomTextField {
                    id: deltaxsRobotID
                    anchors.verticalCenter: deltaxsRobotBtn.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 4
                    width: 100
                    height: 30
                    onTextEnter: {
                        if (deltaxsRobotBtn.isActiveMenu == true){
                            if (deviceManager.changeIdDeltaXRobot(text)){
                                messageDialog.showNote(true, "Changed Address")
                            }
                            else{
                                messageDialog.showNote(false, "Device disconnected")
                            }
                        }
                    }
                }
            }
// Test device
//            Rectangle {
//                color: "transparent"
//                height: parent.height
//                width: (parent.width - 8) / 3
//                radius: 6
//                border.width: 1
//                border.color: "blue"

//                Label {
//                    id: testDeviceLabel
//                    text: "Test Device"
//                    anchors.top: parent.top
//                    anchors.topMargin: 3
//                    font.bold: true
//                    font.pointSize: 10
//                    anchors.leftMargin: 10
//                    anchors.left: parent.left
//                }

//                LedBlinking {
//                    id: rxLedTest
//                    anchors.verticalCenter: testDeviceLabel.verticalCenter
//                    anchors.right: parent.right
//                    anchors.rightMargin: 20
//                }

//                LedBlinking {
//                    id: txLedTest
//                    anchors.verticalCenter: testDeviceLabel.verticalCenter
//                    anchors.right: parent.right
//                    on_color: "green"
//                    anchors.rightMargin: 60
//                }

//                LeftMenuButton {
//                    id: testDeviceBtn
//                    anchors.left: parent.left
//                    anchors.bottom: parent.bottom
//                    anchors.bottomMargin: 3
//                    anchors.leftMargin: 4
//                    onClicked: {
//                        if (isActiveMenu == false) {
//                            deviceManager.connectTestRobot(testDevicePort.getText(), testDeviceID.getText())
//                            //console.log("port:" + deltaxsRobotPort.getText() + " id:" + deltaxsRobotID.getText());
//                        }
//                        else{
//                            deviceManager.disconnectTester()
//                            set_test_disconnected_state();
//                        }
//                    }
//                }

//                CustomComboBox {
//                    id: testDevicePort
//                    anchors.verticalCenter: testDeviceBtn.verticalCenter
//                    anchors.left: testDeviceBtn.right
//                    anchors.right: testDeviceID.left
//                    anchors.rightMargin: 12
//                    anchors.leftMargin: 12

//                }

//                CustomTextField {
//                    id: testDeviceID
//                    anchors.verticalCenter: testDeviceBtn.verticalCenter
//                    anchors.right: parent.right
//                    anchors.rightMargin: 4
//                    onTextEnter: {
//                        if (testDeviceBtn.isActiveMenu == true){
//                            if (deviceManager.changeIdTester(text)){
//                                messageDialog.showNote(true, "Changed Address")
//                            }
//                            else{
//                                messageDialog.showNote(false, "Device disconnected")
//                            }
//                        }
//                    }
//                }
//            }

        }
    }
}
