import QtQuick
import QtQuick.Controls
import "../controls"
import QtQuick3D
import QtQuick3D.Helpers

Item {
    implicitWidth: 1100
    implicitHeight: 600

    Component.onCompleted: {

    }

    Rectangle {
        id: rectangle
        color: "#eeeeee"
        anchors.fill: parent
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.bottomMargin: 2
        anchors.topMargin: 4
        radius: 10

//        RobotView3D {
//            id: robotView3D
//            anchors.top: parent.top
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 0
//            anchors.topMargin: 0
//            anchors.left: parent.left
//            anchors.right: controlPanel.left
//        }

        Rectangle {
            id: controlPanel
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            anchors.right: parent.right
            width: 400
            radius: 10
            border.width: 1
            border.color: "deepskyblue"


            RobotParameterControlPage {
                anchors.fill: parent

                onRobotModelChanged: {
//                    robotView3D.setModelName(_model_name.toLowerCase())
                }
            }

        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}D{i:2}D{i:3}D{i:4}D{i:5}D{i:10}D{i:1}
}
##^##*/
