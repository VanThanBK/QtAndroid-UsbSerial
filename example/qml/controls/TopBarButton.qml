import QtQuick
import QtQuick.Controls

Button{
    id: btnTopBar
    // CUSTOM PROPERTIES
    property url btnIconSource: "qrc:/images/icons8-broom-30.png"
    property color btnColorDefault: "paleturquoise"
    property color btnColorMouseOver: "skyblue"
    property color btnColorClicked: "deepskyblue"

    QtObject{
        id: internal

        // MOUSE OVER AND CLICK CHANGE COLOR
        property var dynamicColor: if(btnTopBar.down){
                                       btnTopBar.down ? btnColorClicked : btnColorDefault
                                   } else {
                                       btnTopBar.hovered ? btnColorMouseOver : btnColorDefault
                                   }

    }

    implicitWidth: 30
    implicitHeight: 30
    //width: 35
    //height: 35

    background: Rectangle{
        id: bgBtn
        color: internal.dynamicColor
        radius: 6
    }

    contentItem: Rectangle{
        id: ctBtn
        color: "transparent"
        radius: 5
        Image {
            id: iconBtn
            source: btnIconSource
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height
            width: parent.width
            visible: true
            fillMode: Image.PreserveAspectFit
            antialiasing: false
        }
    }
}


