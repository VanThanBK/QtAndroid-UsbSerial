import QtQuick
import QtQuick.Controls

Item {
    implicitHeight: 120
    implicitWidth: 270

    signal turnOnAll()
    signal turnOffAll()
    signal changed(string _pin_name, bool is_on)

    property int imageMaxWidth: 180
    property string imagePath: "../../images/DB-15.png"

    function setDigitalState(_pin_name, is_on){
        if (_pin_name === "D0"){
            d0Led.isActive = is_on
        }
        else if (_pin_name === "D1"){
            d1Led.isActive = is_on
        }
        else if (_pin_name === "D2"){
            d2Led.isActive = is_on
        }
        else if (_pin_name === "D3"){
            d3Led.isActive = is_on
        }
        else if (_pin_name === "D4"){
            d4Led.isActive = is_on
        }
        else if (_pin_name === "D5"){
            d5Led.isActive = is_on
        }
        else if (_pin_name === "D6"){
            d6Led.isActive = is_on
        }
        else if (_pin_name === "D7"){
            d7Led.isActive = is_on
        }
    }

    function turnAllDigital(is_on){
        d0Led.isActive = is_on
        d1Led.isActive = is_on
        d2Led.isActive = is_on
        d3Led.isActive = is_on
        d4Led.isActive = is_on
        d5Led.isActive = is_on
        d6Led.isActive = is_on
        d7Led.isActive = is_on

        if (is_on){
            turnOnAll()
        }
        else{
            turnOffAll()
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

    Row {
        id: row1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        height: 20
        width: 270
        spacing: 2

        LedControl {
            id: d0Led
            led_name: "D0"
            onMouseClick: changed(led_name, isActive)
        }

        LedControl {
            id: d1Led
            led_name: "D1"
            onMouseClick: changed(led_name, isActive)
        }

        LedControl {
            id: d2Led
            led_name: "D2"
            onMouseClick: changed(led_name, isActive)
        }

        LedControl {
            id: d3Led
            led_name: "D3"
            onMouseClick: changed(led_name, isActive)
        }

        LedControl {
            id: d4Led
            led_name: "D4"
            onMouseClick: changed(led_name, isActive)
        }

        LedControl {
            id: d5Led
            led_name: "D5"
            onMouseClick: changed(led_name, isActive)
        }

        LedControl {
            id: d6Led
            led_name: "D6"
            onMouseClick: changed(led_name, isActive)
        }

        LedControl {
            id: d7Led
            led_name: "D7"
            onMouseClick: changed(led_name, isActive)
        }
    }

    Text {
        id: text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: image.bottom
        anchors.topMargin: 10
        text: "GND"
        font.bold: true
        font.pointSize: 10
    }

    LedControl {
        id: dallLed
        led_name: "All"
        anchors.verticalCenter: text.verticalCenter
        anchors.left: text.right
        anchors.leftMargin: 30
        width: 40
        onMouseClick: {
            turnAllDigital(isActive)
        }
    }
}
