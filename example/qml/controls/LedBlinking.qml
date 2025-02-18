import QtQuick
import QtQuick.Controls

Item {
    width: 20
    height: 10

    property color off_color: "lightgray"
    property color on_color: "red"

    function startBlinking(loop_count){
        blinking_animation.loops = loop_count;
        blinking_animation.start();
    }

    Rectangle {
        id: ledRect
        color: off_color
        radius: parent.height / 2 - 1
        anchors.fill: parent

        SequentialAnimation {
            id: blinking_animation
            running: true
            loops: 2
            ColorAnimation {target: ledRect; property: "color"; from: off_color; to: on_color; duration: 15 }
            ColorAnimation {target: ledRect; property: "color"; from: on_color; to: off_color;  duration: 15 }
        }

    }
}
