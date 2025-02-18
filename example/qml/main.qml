import QtQuick
import QtQuick.Window
import QtQuick.Controls
import "./pages"

Window {
    id: window
    width: 720
    height: 1280
    visible: true
    title: qsTr("Calibrator")
    minimumHeight: 1080
    minimumWidth: 700

    Rectangle {
        id: topBar
        height: 66
        //color: "#e6e6e6"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        DeviceConnection {
            anchors.fill: parent
        }
    }

    TabBar {
        id: funcBar
        height: 32
        anchors.top: topBar.bottom
        currentIndex: 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 2
        anchors.rightMargin: 2

        Repeater {
            id: repeater
            model: ["Precision Calibration", "Check Movement Parameters", "Test Circuit", "Ether net-cat", "Robot Parameters"]
            TabButton {
                text: modelData
                anchors.verticalCenter: parent.verticalCenter
                height: 32
                width: 200
            }
        }

    }

    SwipeView {
        id: funcView
        anchors.top: funcBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        currentIndex: funcBar.currentIndex
        onCurrentIndexChanged: funcBar.currentIndex = currentIndex
        interactive: false

        PrecisionCalibration {

        }

        CheckMovementParameters {

        }

        TestCircuit {

        }

        EthernetEthercat {

        }

        RobotParameters {

        }
    }
}


