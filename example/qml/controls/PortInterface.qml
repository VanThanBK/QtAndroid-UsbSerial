import QtQuick
import QtQuick.Controls

Item {
    implicitHeight: 100
    implicitWidth: 240

    signal portChanged(bool is_open, string baudrate)

    property string sw_name: "USB1"
    property int imageMaxWidth: 180
    property string imagePath: "../../images/usb_type_b_v_text.png"

    function set(is_open, baudrate){
        customSwitch.checked = is_open
        baudrateTf.setText(baudrate);
    }

    Component.onCompleted: {
        baudrateTf.setLimit(9600, 230400);
    }

    Image {
        id: image
        source: imagePath
        fillMode: Image.PreserveAspectFit
        anchors.top: parent.top
        width: (parent.width > imageMaxWidth)?imageMaxWidth:parent.width
        anchors.horizontalCenter: parent.horizontalCenter

    }

    CustomSwitch {
        id: customSwitch
        text: sw_name
        height: 20
        width: 80
        anchors.left: parent.left
        anchors.top: image.bottom
        anchors.topMargin: 8
        onClicked: {
            if (isNaN(baudrateTf.getNumber())){
                customSwitch.checked = false
                return
            }

            portChanged(customSwitch.checked, baudrateTf.getText())
        }
    }

    CustomTextFieldNumber {
        id: baudrateTf
        labelString: "Baudrate:"
        width: 130
        height: 24
        anchors.left: customSwitch.right
        anchors.leftMargin: 12
        anchors.verticalCenter: customSwitch.verticalCenter
        colorBorder: "black"
        onTextEnter: {
            if ( isNaN(baudrateTf.getNumber())){
                customSwitch.checked = false
                return
            }
            if (customSwitch.checked){
                portChanged(customSwitch.checked, baudrateTf.getText())
            }
        }
    }
}
