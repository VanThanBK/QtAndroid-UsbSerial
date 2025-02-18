import QtQuick
import QtQuick.Controls

Rectangle {
    signal mouseClick(string _name)

    property color defaultColor: "#d1d1d1"
    property color activeColor: "green"
    property color errorColor: "red"

    property bool isActive: false
    property string led_name: "I0"

    property bool is_autoChangeState: true

    implicitHeight: 20
    implicitWidth: 30
    radius: 8

    border.width: 1
    color: (isActive)?activeColor:defaultColor

    Text {
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 10
        text: led_name
    }

    MouseArea {
        anchors.fill: parent
        onClicked:{
            if (is_autoChangeState){
                isActive = !isActive
            }
            mouseClick(led_name)
        }
    }
}
