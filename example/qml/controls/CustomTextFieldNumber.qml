import QtQuick
import QtQuick.Controls


Item {
    id: textField

    signal textEnter(string text);
    signal textFinish(string text);
    // Custom Properties
    //color: "transparent"
    property color colorDefault: "transparent"
    property color colorOnFocus: "#242831"
    property color colorMouseOver: "#2B2F38"
    property string labelString: "ID"
    property string holderString: ""

    property color colorBorder: "#aaaaaa"

    property int max_number: 100000
    property int min_number: -100000

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
        min_number = _min
        max_number = _max
    }

    function setNumber(_number)
    {
        textFieldInput.text = _number.toString()
    }

    function getNumber()
    {
        return parseFloat(textFieldInput.text)
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

        background: Rectangle {
            color: internal.dynamicColor
            radius: 6
            border.color: colorBorder
            border.width: 1
            anchors.bottomMargin: 10
            anchors.fill: parent
        }

        selectByMouse: true
        selectedTextColor: "#FFFFFF"
        selectionColor: "#ff007f"
        placeholderTextColor: "#81848c"

        onAccepted: textEnter(text)

        onEditingFinished: {
            if (textFieldInput.text === ""){
                return
            }
            if (isNaN(parseFloat(textFieldInput.text)))
            {
                textFieldInput.text = ""
                return
            }
            if (parseFloat(textFieldInput.text) > max_number || parseFloat(textFieldInput.text) < min_number){
                textFieldInput.text = ""
                return
            }

            textFinish(textFieldInput.text)
        }
    }
}


