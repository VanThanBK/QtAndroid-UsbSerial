import QtQuick
import QtQuick.Controls
import "../controls"

Rectangle{
    implicitHeight: 600
    implicitWidth: 1100
    clip: true
    color: "transparent"

    Connections {
        target: testCircuitControl

        function onUpdatedDigitalInput(_pin_name, is_on){
            digitalInput.setInput(_pin_name, is_on)
            estopInput.setInput(_pin_name, is_on)
        }

        function onUpdatedAnalogInput(_pin_name, is_on){
            digitalInput.setInputAnalog(_pin_name, is_on)
        }

        function onUpdatedOutputInfor(_pin_name, is_on){
            digitalOutput.setDigitalState(_pin_name, is_on)
        }

        function onUpdatedUsb1Infor(is_on, _baudrate){
            usb1Port.set(is_on, _baudrate);
        }

        function onUpdatedRs232Infor(is_on, _baudrate){
            rs232Port.set(is_on, _baudrate);
        }

        function onUpdatedRs485Infor(is_on, _baudrate){
            rs485Port.set(is_on, _baudrate);
        }

        function onUpdateDataToRobotTermite(_data){
            termiteText.text += _data;

            var vbar_position = 1 - (termiteRec.height / termiteText.height)
            if (vbar_position > 0){
                vbar.position = vbar_position
            }

        }
    }

    CustomMessageDialog {
        id: messageDialog
    }

    Image {
        id: imageCircuitV5
        source: "../../images/v5_circuit_panel.PNG"
        fillMode: Image.PreserveAspectFit
        height: 600
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }

    Rectangle {
        id: leftPanel
        anchors.left: parent.left
        anchors.right: imageCircuitV5.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "transparent"

        PortInterface {
            id: usb1Port
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            height: 90
            anchors.topMargin: 10
            onPortChanged: {

                testCircuitControl.setUsb1Enable(is_open, baudrate)
            }
        }

        PortInterface {
            id: rs232Port
            anchors.horizontalCenter: parent.horizontalCenter
            imagePath: "../../images/db9-rs232_pin.png"
            height: 120
            y: parent.height * 1 / 4
            sw_name: "RS232"
            onPortChanged: {
                testCircuitControl.setRs232Enable(is_open, baudrate)
            }
        }

        PortInterface {
            id: rs485Port
            anchors.horizontalCenter: parent.horizontalCenter
            imagePath: "../../images/db9-rs485_pin.png"
            height: 120
            y: parent.height * 2 / 4
            sw_name: "RS485"
            onPortChanged: {
                testCircuitControl.setRs485Enable(is_open, baudrate)
            }
        }

        InputControl {
            id: digitalInput
            anchors.horizontalCenter: parent.horizontalCenter
            imagePath: "../../images/db9.PNG"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            onGetInput: {
                testCircuitControl.getInput()
            }
            onAutoReadInput: {
                testCircuitControl.setAutoReadInput(is_on)
            }
        }
    }

    Rectangle {
        id: rightPanel
        anchors.right: parent.right
        anchors.left: imageCircuitV5.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "transparent"

        LeftMenuButton {
            id: reload
            anchors.top: parent.top
            anchors.topMargin: 10
            btnIconSource: "qrc:/images/icons8-refresh-24.png"
            text: "Reload"
            btnColorDefault: "tomato"
            anchors.left: parent.left
            anchors.leftMargin: 20
            onClicked: {
                testCircuitControl.reloadIO()
            }
        }

        LeftMenuButton {
            id: autoTest
            anchors.verticalCenter: reload.verticalCenter
            anchors.left: reload.right
            anchors.leftMargin: 16
            btnIconSource: "qrc:/images/icons8-automatic-contrast-24.png"
            text: "Auto Test"
            btnColorDefault: "teal"
        }

        Rectangle {
            id: termiteRec
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: reload.bottom
            anchors.rightMargin: 4
            anchors.topMargin: 30
            height: 120
            color: "transparent"
            border.width: 1
            radius: 5
            clip: true

            ScrollBar {
                id: vbar
                hoverEnabled: true
                active: hovered || pressed
                orientation: Qt.Vertical
                size: parent.height / termiteText.height
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.rightMargin: 1
                policy: ScrollBar.AlwaysOn
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.MiddleButton
                onWheel: {
                    if (!wheel) {
                        return
                    }
                    if (wheel.angleDelta.y < 0){
                        vbar.increase()
                    }
                    else if (wheel.angleDelta.y > 0){
                        vbar.decrease()
                    }
                }
            }

            Text {
                id: termiteText
                text: qsTr("")
                anchors.left: parent.left
                anchors.right: parent.right
                wrapMode: Text.WordWrap
                font.pointSize: 10
                anchors.rightMargin: vbar.width + 1
                y: -vbar.position * (height)
                leftPadding: 2

            }
        }

        CustomTextField {
            id: gcodeTextField
            labelString: ""
            anchors.left: parent.left
            anchors.top: termiteRec.bottom
            anchors.topMargin: 6
            anchors.right: gcodeSendBtn.left
            anchors.rightMargin: 6
            onTextEnter: {
                testCircuitControl.sendGcodeToRobot(text)
            }
        }

        LeftMenuButton {
            id: gcodeSendBtn
            anchors.verticalCenter: gcodeTextField.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 6
            btnText: "Send"
            btnIconSource: "qrc:/images/icons8-send-letter-24.png"
            btnColorDefault: "deepskyblue"
            width: 68

            onClicked: {
                testCircuitControl.sendGcodeToRobot(gcodeTextField.getText())
            }
        }


        EstopControl {
            id: estopInput
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height * 2 / 4
            onEstopEnable: {
                testCircuitControl.setEStopEnable(is_on)
            }
        }

        OutputControl {
            id: digitalOutput
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            onTurnOffAll: {
                testCircuitControl.setAllDigitalOutput(false);
            }
            onTurnOnAll: {
                testCircuitControl.setAllDigitalOutput(true);
            }
            onChanged: {
                testCircuitControl.setDigitalOutput(_pin_name, is_on)
            }
        }
    }

}
/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
