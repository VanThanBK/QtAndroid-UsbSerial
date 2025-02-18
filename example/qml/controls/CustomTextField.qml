import QtQuick
import QtQuick.Controls


Rectangle {
    id: textField

    signal textEnter(string text);
    // Custom Properties
    color: "transparent"
    property color colorDefault: "transparent"
    property color colorOnFocus: "#242831"
    property color colorMouseOver: "#2B2F38"
    property string labelString: "ID"
    property string holderString: ""

    implicitWidth: 90
    implicitHeight: 26

    function getText()
    {
        return textFieldInput.text
    }

    function setText(textInput)
    {
        textFieldInput.text = textInput;
    }

    function enableInput()
    {
        textFieldInput.enabled = true;
    }

    function disabledInput()
    {
        textFieldInput.enabled = false;
    }

    function setLimit(_min, _max)
    {

    }

    Text {
        id: textFieldtext
        text: textField.labelString
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        font.pointSize: 12
        anchors.leftMargin: 0

    }

    TextField {
        id: textFieldInput
        QtObject{
            id: internal
            property var dynamicColor: if(textField.focus){
                                            textField.hovered ? colorOnFocus : colorDefault
                                       }else{
                                           textField.hovered ? colorMouseOver : colorDefault
                                       }
        }

        placeholderText: textField.holderString
        color: "#000000"
        anchors.left: textFieldtext.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        verticalAlignment: TextInput.AlignVCenter
        horizontalAlignment: TextInput.AlignHCenter

        font.pointSize: 12
        anchors.topMargin: 0
        anchors.bottomMargin: -10
        anchors.leftMargin: 6
        anchors.rightMargin: 0
        //inputMethodHints: Qt.ImhDigitsOnly

        background: Rectangle {
            color: internal.dynamicColor
            radius: 6
            border.color: "#aaaaaa"
            border.width: 1
            anchors.fill: parent
            anchors.bottomMargin: 10
        }

        selectByMouse: true
        selectedTextColor: "#FFFFFF"
        selectionColor: "#ff007f"
        placeholderTextColor: "#81848c"

        onAccepted: textEnter(text)
    }
}


