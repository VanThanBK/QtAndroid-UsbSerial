import QtQuick
import QtQuick.Controls

Item {
    implicitHeight: 100
    implicitWidth: 240

    signal estopEnable(bool is_on)

    property int imageMaxWidth: 180
    property string imagePath: "../../images/estop_pin.PNG"

    function setInput(_pin_name, is_on){
        if (_pin_name === "I4"){
            i4Led.isActive = is_on
        }
        else if (_pin_name === "I5"){
            i5Led.isActive = is_on
        }
    }

    Image {
        id: image
        source: imagePath
        fillMode: Image.PreserveAspectFit
        anchors.top: row1.bottom
        anchors.topMargin: 6
        width: (parent.width > imageMaxWidth)?imageMaxWidth:parent.width
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Row {
        id: row1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        height: 20
        width: 150
        spacing: 12

        Text {
            height: 20
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.pointSize: 10
            text: "GND"
        }

        LedControl {
            id: i5Led
            led_name: "I5"
            is_autoChangeState: false
        }

        LedControl {
            id: i4Led
            led_name: "I4"
            is_autoChangeState: false
        }

        Text {
            height: 20
            color: "#ad0909"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.pointSize: 10
            text: "24V"
        }
    }

    CustomSwitch {
        id: autoRead
        text: "EStop Enable"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: image.bottom
        anchors.topMargin: 8
        height: 20
        width: 110
        onCheckedChanged: estopEnable(checked)
    }
}
