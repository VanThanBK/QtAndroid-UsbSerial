import QtQuick
import QtQuick.Controls

Switch {
    id: control
    text: qsTr("Switch")
    implicitWidth: 48
    implicitHeight: 26

    indicator: Rectangle {
        width: parent.height * 2
        height: parent.height
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 13
        color: control.checked ? "#17a81a" : "#ffffff"
        border.color: control.checked ? "#17a81a" : "#cccccc"

        Rectangle {
            x: control.checked ? parent.width - width : 0
            width: parent.height
            height: parent.height
            radius: parent.height / 2
            color: control.down ? "#cccccc" : "#ffffff"
            border.color: control.checked ? (control.down ? "#17a81a" : "#21be2b") : "#999999"
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? "black" : "black"
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
