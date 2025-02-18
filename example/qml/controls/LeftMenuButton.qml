import QtQuick
import QtQuick.Controls
//import QtGraphicalEffects 1.15


Button{
    id: btnLeftMenu
    text: internal.dynamicText
    font.pointSize: 10

    // CUSTOM PROPERTIES
    property string btnText: "Connect"
    property string btnTextActive: "Disconnect"
    property url btnIconSource: "../../images/icons8-disconnected-24.png"
    property url btnIconSourceActive: "../../images/icons8-connected-24.png"
    property color btnColorDefault: "paleturquoise"
    property color btnColorDefaultActive: "salmon"
    property color btnColorMouseOver: "skyblue"
    property color btnColorClicked: "deepskyblue"
    property int iconWidth: 24
    property int iconHeight: 24
    property bool isActiveMenu: false
    height: 30
    width: 106

    QtObject{
        id: internal

        // MOUSE OVER AND CLICK CHANGE COLOR
        property var dynamicColor: if(btnLeftMenu.down){
                                       btnLeftMenu.down ? btnColorClicked : (isActiveMenu ? btnColorDefaultActive : btnColorDefault)
                                   } else {
                                       btnLeftMenu.hovered ? btnColorMouseOver : (isActiveMenu ? btnColorDefaultActive : btnColorDefault)
                                   }

        property var dynamicText: if(btnLeftMenu.isActiveMenu){
                                       btnTextActive
                                   } else {
                                       btnText
                                   }
        property var dynamicUrl: if(btnLeftMenu.isActiveMenu){
                                       btnIconSourceActive
                                   } else {
                                       btnIconSource
                                   }
    }

    implicitWidth: 106
    implicitHeight: 30

    background: Rectangle{
        id: bgBtn
        color: internal.dynamicColor
        radius: 16
    }

    contentItem: Item{
        anchors.fill: parent
        id: content
        //width: 150
        //height: 48

        Image {
            id: iconBtn
            source: internal.dynamicUrl
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            sourceSize.width: iconWidth
            sourceSize.height: iconHeight
            width: iconWidth
            height: iconHeight
            fillMode: Image.PreserveAspectFit
            visible: true
            antialiasing: true

        }

        Text{
            color: "#000000"
            text: btnLeftMenu.text
            font: btnLeftMenu.font
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            anchors.rightMargin: 6
            anchors.leftMargin: iconWidth + 10
        }
    }
}




/*##^##
Designer {
    D{i:0;formeditorZoom:6}
}
##^##*/
