import QtQuick
import QtQuick.Controls

Item {
    id: item1
    width: 60
    height: 160
    implicitHeight: 100
    implicitWidth: 50

    property string sliderName: "T1"

    function setValue(_value) {
        value.text = _value.toString()

        if (Math.abs(_value) < 0.6) {
            sliderBot.color = "limegreen"
            sliderTop.color = "limegreen"
        }
        else if (0.6 <= Math.abs(_value) && Math.abs(_value) < 1.0) {
            sliderBot.color = "goldenrod"
            sliderTop.color = "goldenrod"
        }
        else {
            sliderBot.color = "crimson"
            sliderTop.color = "crimson"
        }

        if (_value > 0) {
            sliderBot.visible = false
            sliderBot.height = 0

            sliderTop.visible = true
            sliderTop.height = _value * 50;
        }
        else {
            sliderBot.visible = true
            sliderBot.height = -_value * 50

            sliderTop.visible = false
            sliderTop.height = 0;
        }

        if (sliderBot.height > 57) {
            sliderBot.height = 57;
        }
        if (sliderTop.height > 57) {
            sliderTop.height = 57;
        }
    }

    Text {
        id: sliderText
        color: "#000000"
        text: item1.sliderName
        anchors.top: parent.top
        anchors.horizontalCenter: slideBorder.horizontalCenter
        font.pointSize: 10
        anchors.topMargin: 3
    }

    Rectangle {
        id: slideBorder
        width: 20
        color: "#b1c3ce"
        radius: 4
        border.color: "#385183"
        anchors.left: parent.left
        anchors.top: sliderText.bottom
        anchors.bottom: value.top
        clip: true
        anchors.bottomMargin: 3
        anchors.leftMargin: 4
        anchors.topMargin: 0

        Rectangle {
            id: sliderTop
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.verticalCenter
            color: "limegreen"
            radius: 3
            anchors.leftMargin: 1
            anchors.rightMargin: 1
        }

        Rectangle {
            id: sliderBot
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.verticalCenter
            color: "limegreen"
            radius: 3
            anchors.leftMargin: 1
            anchors.rightMargin: 1
        }
    }

    Text {
        id: value
        color: "#000000"
        text: qsTr("0.0")
        anchors.horizontalCenter: slideBorder.horizontalCenter
        anchors.bottom: parent.bottom
        font.pointSize: 10
        anchors.bottomMargin: 3
    }

    Text {
        id: middleValue
        color: "#000000"
        text: qsTr("----  0.0")
        anchors.verticalCenter: slideBorder.verticalCenter
        anchors.left: slideBorder.left
        anchors.leftMargin: 0
        font.pointSize: 10
        anchors.verticalCenterOffset: -2
    }

    Text {
        id: topValue1
        color: "#000000"
        text: qsTr("---- +0.6")
        anchors.verticalCenter: slideBorder.verticalCenter
        anchors.left: slideBorder.left
        anchors.verticalCenterOffset: -32
        anchors.leftMargin: 0
        font.pointSize: 10
    }

    Text {
        id: topValue2
        color: "#000000"
        text: qsTr("---- +1.0")
        anchors.verticalCenter: slideBorder.verticalCenter
        anchors.left: slideBorder.left
        anchors.verticalCenterOffset: -52
        anchors.leftMargin: 0
        font.pointSize: 10
    }

    Text {
        id: bottomValue1
        color: "#000000"
        text: qsTr("---- -0.6")
        anchors.verticalCenter: slideBorder.verticalCenter
        anchors.left: slideBorder.left
        anchors.verticalCenterOffset: 28
        anchors.leftMargin: 0
        font.pointSize: 10
    }

    Text {
        id: bottomValue2
        color: "#000000"
        text: qsTr("---- -1.0")
        anchors.verticalCenter: slideBorder.verticalCenter
        anchors.left: slideBorder.left
        anchors.verticalCenterOffset: 48
        anchors.leftMargin: 0
        font.pointSize: 10
    }
}
