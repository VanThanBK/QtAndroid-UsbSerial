import QtQuick
import QtQuick.Controls

Rectangle {
    id: customComboBox

    signal indexChanged()

    property string labelString: "Port"
    property color colorDefault: "transparent"
    property color colorBorder: "#aaaaaa"

    color: "transparent"
    height: 30
    width: 90
    implicitWidth: 90
    implicitHeight: 30

    function getText()
    {
        return comboBoxInput.currentValue
    }

    function setText(textInput)
    {
        comboBoxInput.currentIndex = comboBoxInput.indexOfValue(textInput)
    }

    function enableInput()
    {
        comboBoxInput.enabled = true
    }

    function disableInput()
    {
        comboBoxInput.enabled = false
    }

    function setCurrentIndex(index)
    {
        comboBoxInput.currentIndex = index
    }

    function clearList()
    {
        modelPort.clear()
        comboBoxInput.currentIndex = 0
    }

    function addElement(portname)
    {
        modelPort.append({ text: portname} )
    }

    Text {
        id: comboBoxText
        text: customComboBox.labelString
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        font.pointSize: 10
        anchors.leftMargin: 0

    }

    ComboBox {
        id: comboBoxInput
        anchors.left: comboBoxText.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        font.pointSize: 10
        anchors.leftMargin: 6
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.topMargin: 0

        model: ListModel {
                id: modelPort
                ListElement { text: "Auto" }
                ListElement { text: "COM1" }
            }

        background: Rectangle {
            radius: 6
            border.width: 1
            color: customComboBox.colorDefault
            border.color: colorBorder
//            Image {
//                source: "qrc:/images/icons8-sort-down-24.png"
//                anchors.verticalCenter: parent.verticalCenter
//                anchors.right: parent.right
//            }
        }

        onCurrentValueChanged: indexChanged()
    }
}
