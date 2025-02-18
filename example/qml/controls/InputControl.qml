import QtQuick
import QtQuick.Controls

Item {
    implicitHeight: 140
    implicitWidth: 240

    signal getInput()
    signal autoReadInput(bool is_on)

    property int imageMaxWidth: 180
    property string imagePath: "../../images/usb_type_b_v_text.png"

    Component.onCompleted: {
        a0Text.disabledInput()
        a1Text.disabledInput()
    }

    function setInput(_pin_name, is_on){
        if (_pin_name === "I0"){
            i0Led.isActive = is_on
        }
        else if (_pin_name === "I1"){
            i1Led.isActive = is_on
        }
        else if (_pin_name === "I2"){
            i2Led.isActive = is_on
        }
        else if (_pin_name === "I3"){
            i3Led.isActive = is_on
        }
    }

    function setInputAnalog(_pin_name, is_on){
        if (_pin_name === "A0"){
            a0Text.setText(is_on)
        }
        else if (_pin_name === "A1"){
            a1Text.setText(is_on)
        }
    }

    Image {
        id: image
        source: imagePath
        fillMode: Image.PreserveAspectFit
        anchors.top: row1.bottom
        anchors.topMargin: 8
        width: (parent.width > imageMaxWidth)?imageMaxWidth:parent.width
        anchors.horizontalCenter: parent.horizontalCenter

    }

    CustomSwitch {
        id: autoRead
        text: "Auto"
        anchors.left: image.right
        anchors.leftMargin: 10
        anchors.bottom: image.bottom
        height: 20
        onCheckedChanged: autoReadInput(checked)
    }

    LeftMenuButton {
        anchors.left: image.right
        anchors.leftMargin: 12
        anchors.top: image.top
        height: 30
        text: "Get"
        btnIconSource: "qrc:/images/icons8-down-30.png"
        width: 80
        btnColorDefault: "mediumturquoise"
        onClicked: getInput()
    }

    Row {
        id: row1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        height: 20
        width: 196
        spacing: 12

        LedControl {
            id: i0Led
            led_name: "I0"
            is_autoChangeState: false
        }

        LedControl {
            id: i1Led
            led_name: "I1"
            is_autoChangeState: false
        }

        LedControl {
            id: i2Led
            led_name: "I2"
            is_autoChangeState: false
        }

        LedControl {
            id: i3Led
            led_name: "I3"
            is_autoChangeState: false
        }

        Text {
            height: 20
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.pointSize: 10
            text: "GND"
        }
    }

    Row {
        id: row2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        height: 30
        width: 230
        spacing: 10

        CustomTextFieldNumber {
            id: a0Text
            labelString: "A0"
            height: 24
            width: 70
            colorBorder: "black"

        }

        CustomTextFieldNumber {
            id: a1Text
            labelString: "A1"
            height: 24
            width: 70
            colorBorder: "black"
        }

        Text {
            height: 24
            color: "#ad0909"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.pointSize: 10
            text: "24V"
        }

        Text {
            height: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.pointSize: 10
            text: "GND"
        }
    }
}
