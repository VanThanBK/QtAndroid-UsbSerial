import QtQuick
import QtQuick.Controls
import "../controls"

Item {
    implicitWidth: 1100
    implicitHeight: 600
    Rectangle {
        color: "#e6e6e6"
        anchors.fill: parent
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.bottomMargin: 2
        anchors.topMargin: 4
        radius: 10

        Rectangle {
            id: configPannel
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: parent.width / 2
            color: "transparent"
            radius: 8
            border.width: 1
            border.color: "dodgerblue"

            Text {
                text: qsTr("Config")
                anchors.top: parent.top
                font.bold: false
                anchors.left: parent.left
                anchors.leftMargin: 10
                font.pointSize: 12
                anchors.topMargin: 4
            }


        }

        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.left: configPannel.right
            anchors.leftMargin: 2
            color: "transparent"
            radius: 8
            border.width: 1
            border.color: "dodgerblue"

            Text {
                text: qsTr("Test")
                anchors.top: parent.top
                font.bold: false
                anchors.left: parent.left
                anchors.leftMargin: 10
                font.pointSize: 12
                anchors.topMargin: 4
            }
        }
    }
}
