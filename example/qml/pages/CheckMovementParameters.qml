import QtQuick
import QtQuick.Controls
import "../controls"

Item {
    implicitWidth: 1100
    implicitHeight: 600

    Connections {
        target: movementChecker
        function onUpdateDataToRobotTermite(_data){
            termiteText.text += _data;

            var vbar_position = 1 - (termiteRec.height / termiteText.height)
            if (vbar_position > 0){
                vbar.position = vbar_position
            }
        }
    }

    Rectangle {
        id: rectangle
        color: "#e6e6e6"
        anchors.fill: parent
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.bottomMargin: 2
        anchors.topMargin: 4
        radius: 10

        MovingCharts {
            id: scurveCharts
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 160
        }

        Rectangle {
            id: termiteRec
            anchors.right: parent.right
            anchors.top: scurveCharts.bottom
            anchors.rightMargin: 10
            anchors.topMargin: 10
            height: 100
            width: 420
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

        Rectangle {
            color: "transparent"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.rightMargin: 10
            height: gcodeTextField.height
            width: 420

            CustomTextField {
                id: gcodeTextField
                labelString: "Gcode"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                width: 330

                onTextEnter: {
                    movementChecker.sendGcodeToRobot(text)
                }
            }

            LeftMenuButton {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.left: gcodeTextField.right
                anchors.leftMargin: 6
                btnText: "Send"
                btnIconSource: "qrc:/images/icons8-send-letter-24.png"
                btnColorDefault: "deepskyblue"

                onClicked: {
                    movementChecker.sendGcodeToRobot(gcodeTextField.getText())
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
