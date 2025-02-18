import QtQuick
import QtQuick.Controls

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

        DeltaXSV5CircuitPanel {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

        }
    }
}
