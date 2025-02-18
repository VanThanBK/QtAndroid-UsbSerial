import QtQuick
import QtQuick.Controls

Popup {
    id: popup
    height: 60
    width: 220

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    property bool is_done: false
    property string note_text : ""

    function showNote(_is_done, _note_text){
        is_done = _is_done;
        note_text = _note_text;
        popup.open()
    }

    background: Rectangle {
        radius: 6
        color: "silver"
        border.width: 1
    }

    contentItem: Item {
        id: item1
        Image {
            id: image
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: 36
            width: 36
            fillMode: Image.PreserveAspectFit
            source: (is_done)? "qrc:/images/icons8-check-circle-60.png" : "qrc:/images/icons8-no-error-48.png"
        }

        Text {
            id: name
            text: note_text
            anchors.verticalCenter: image.verticalCenter
            anchors.left: image.right
            anchors.right: topBarButton.left
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 11
            anchors.leftMargin: 6
        }

        TopBarButton {
            id: topBarButton
            anchors.verticalCenter: image.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 0
            btnIconSource: "qrc:/images/icons8-ok-hand-30_black.png"
            onClicked: {
                popup.close()
            }
        }
    }
}
