import QtQuick
import QtQuick3D

MouseArea {
    id: orboitCameraController

    property int current_x: 0
    property int current_y: 0

    property int current_camera_euler_x: 0
    property int current_camera_euler_y: 0
    property int current_camera_pivot_x: 0
    property int current_camera_pivot_y: 0
    property PerspectiveCamera targetCamera: null

    acceptedButtons: Qt.AllButtons
    property bool isPressing: false
    property int mouseButton: 0

    onPressed: {
        if (!mouse) {
            return
        }
        mouseButton = mouse.button
        if (mouse.button === Qt.RightButton || mouse.button === Qt.MiddleButton) {
            current_x = mouse.x
            current_camera_euler_x = targetCamera.eulerRotation.x
            current_camera_euler_y = targetCamera.eulerRotation.y
            current_camera_pivot_x = targetCamera.pivot.x
            current_camera_pivot_y = targetCamera.pivot.y
            current_y = mouse.y
            isPressing = true
        }
    }

    onReleased: {
        if (mouse.button === Qt.RightButton || mouse.button === Qt.MiddleButton) {
            isPressing = false
        }
    }

    onPositionChanged: {
        if (isPressing == false){
            return
        }
        if (mouseButton === Qt.RightButton) {
            var offset_x = mouse.x - current_x
            var offset_y = mouse.y - current_y
            targetCamera.eulerRotation.y = current_camera_euler_y - offset_x / 3
            targetCamera.eulerRotation.x = current_camera_euler_x - offset_y / 3
        }
        else if (mouseButton === Qt.MiddleButton) {
            var offset1_x = mouse.x - current_x
            var offset1_y = mouse.y - current_y
            targetCamera.pivot.x = current_camera_pivot_x + offset1_x
            targetCamera.pivot.y = current_camera_pivot_y - offset1_y
        }
    }

    onWheel: {
        if (!wheel) {
            return
        }
        targetCamera.pivot.z += wheel.angleDelta.y
    }
}
