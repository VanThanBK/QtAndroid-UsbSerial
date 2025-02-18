import QtQuick
import QtQuick.Controls
import "../controls"

Item {
    id: item
    width: 720
    height: 1188

    function forwardCal(){
        if (t1Tf.getText() === "" || t2Tf.getText() === "" || t3Tf.getText() === ""){
            return
        }

        calibrationControl.forwardKinematic(t1Tf.getNumber(), t2Tf.getNumber(), t3Tf.getNumber())
    }

    function inverseCal(){
        if (xTf.getText() === "" || yTf.getText() === "" || zTf.getText() === ""){
            return
        }

        calibrationControl.inverseKinematic(xTf.getNumber(), yTf.getNumber(), zTf.getNumber())
    }

    QtObject{
        id: internal
        property var isVertical: (item.height >= item.width)?true:false;
    }

    Rectangle {
        color: "#e6e6e6"
        anchors.fill: parent
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.bottomMargin: 2
        anchors.topMargin: 4
        radius: 10
        clip: true

        Component.onCompleted: {
            t1Tf.setLimit(-60, 90)
            t2Tf.setLimit(-60, 90)
            t3Tf.setLimit(-60, 90)
            xTf.setLimit(-600, 600)
            yTf.setLimit(-600, 600)
            zTf.setLimit(-1000, -100)
            homeXTf.setLimit(-600, 600)
            homeYTf.setLimit(-600, 600)
            homeZTf.setLimit(-1000, -100)
            radiusTest.setLimit(0, 600)
            zdownTest.setLimit(-1000, -100)
            aTest.setLimit(0, 500)
            bTest.setLimit(0, 500)
            cTest.setLimit(0, 500)
        }

        Connections {
            target: calibrationControl

            function onUpdatedAngleCal(_t1, _t2, _t3){
                _t1 = _t1.toFixed(3);
                _t2 = _t2.toFixed(3);
                _t3 = _t3.toFixed(3);
                t1Tf.setNumber(_t1)
                t2Tf.setNumber(_t2)
                t3Tf.setNumber(_t3)
            }

            function onUpdatedPointCal(_x, _y, _z){
                _x = _x.toFixed(2);
                _y = _y.toFixed(2);
                _z = _z.toFixed(2);
                xTf.setNumber(_x)
                yTf.setNumber(_y)
                zTf.setNumber(_z)
            }

            function onNewNotification(_is_done, _noti){
                messageDialog.showNote(_is_done, _noti)
            }

            function onUpdateErrorAngle(_t1, _t2, _t3){
                _t1 = _t1.toFixed(3);
                _t2 = _t2.toFixed(3);
                _t3 = _t3.toFixed(3);

                t1ErrorSlide.setValue(_t1)
                t2ErrorSlide.setValue(_t2)
                t3ErrorSlide.setValue(_t3)
            }
        }

        CustomMessageDialog {
            id: messageDialog

        }

        Rectangle {
            id: controlPanel
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            // width: 380
            anchors.left: parent.left
            color: "transparent"
            radius: 10
            border.width: 1
            border.color: "deepskyblue"

            LeftMenuButton {
                id: robotHomeBtn
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 6
                anchors.leftMargin: 6
                btnText: "Home"
                btnIconSource: "qrc:/images/icons8-home-24.png"
                btnColorDefault: "sandybrown"
                width: 88
                height: 54

                onClicked: calibrationControl.homeRobot()
            }

            Rectangle {
                id: beltTensionPanel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: robotHomeBtn.bottom
                anchors.topMargin: 10
                anchors.leftMargin: 8
                anchors.rightMargin: (internal.isVertical)?0:(parent.width/2)
                height: 160
                color: "transparent"

                //test
//                border.width: 1
//                border.color: "red"

                VolumeSlider {
                    id: t1ErrorSlide
                    sliderName: "T1"
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }

                VolumeSlider {
                    id: t2ErrorSlide
                    sliderName: "T2"
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 105
                }

                VolumeSlider {
                    id: t3ErrorSlide
                    sliderName: "T3"
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 200
                }

                LeftMenuButton {
                    id: autoReadErrorBtn
                    anchors.verticalCenter: beltTensionPanel.verticalCenter
                    anchors.right:  beltTensionPanel.right
                    anchors.rightMargin: 10
                    btnText: "Read"
                    btnTextActive: "Stop"
                    btnIconSource: "qrc:/images/icons8-down-30.png"
                    btnIconSourceActive: "qrc:/images/icons8-unavailable-24.png"
                    btnColorDefault: "darkseagreen"
                    width: 88
                    height: 54

                    onClicked: {
                        if (autoReadErrorBtn.isActiveMenu == false) {
                            calibrationControl.readErrorAngle();
                            autoReadErrorBtn.isActiveMenu = true;
                        }
                        else {
                            calibrationControl.stopReadErrorAngle();
                            autoReadErrorBtn.isActiveMenu = false;
                        }

                    }
                }
            }

            Rectangle {
                id: stepPerPiPanel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: homePositionPanel.top
                anchors.bottomMargin: 16
                anchors.leftMargin: (internal.isVertical)?8:(parent.width/2)
                height: 140
                color: "transparent"

                //test
//                border.width: 1
//                border.color: "red"

                Text {
                    text: qsTr("Adjust Step Per 2Pi")
                    font.pointSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: 26
                }

                Grid {
                    id: grid3
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: 26
                    anchors.rightMargin: 110
                    spacing: 10
                    columns: 2
                    rows: 1
                    height: 26

                    CustomTextFieldNumber {
                        id: radiusTest
                        labelString: "Radius:"
                        height: 26
                        width: 116
                    }

                    CustomTextFieldNumber {
                        id: zdownTest
                        labelString: "Z Down:"
                        height: 26
                        width: 120
                    }
                }

                LeftMenuButton {
                    btnText: "Center"
                    width: 80
                    height: 54
                    anchors.verticalCenter: grid3.verticalCenter
                    anchors.left: grid3.right

                    btnIconSource: "qrc:/images/icons8-move-left-24.png"
                    btnColorDefault: "goldenrod"

                    onClicked: {
                        if (radiusTest.getText() === "" || zdownTest.getText() === ""){
                            return
                        }

                        calibrationControl.moveCenterPoint(zdownTest.getNumber())
                    }
                }

                LeftMenuButton {
                    id: setHomePositionBtn
                    anchors.verticalCenter: grid4.verticalCenter
                    anchors.left: grid4.right
                    btnText: "Adjust"
                    btnIconSource: "qrc:/images/icons8-adjust-24.png"
                    btnColorDefault: "darksalmon"
                    width: 90
                    height: 54

                    onClicked: {
                        if (radiusTest.getText() === "" || zdownTest.getText() === ""){
                            return
                        }
                        if (aTest.getText() === "" || bTest.getText() === "" || cTest.getText() === ""){
                            return
                        }

                        calibrationControl.setNewStepPer2Pi(radiusTest.getNumber(), aTest.getNumber(), bTest.getNumber(), cTest.getNumber())
                    }
                }

                Grid {
                    id: grid4
                    anchors.top: grid3.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: 0
                    anchors.rightMargin: 110
                    spacing: 6
                    columns: 3
                    rows: 2
                    height: 100

                    LeftMenuButton {
                        btnText: "A"
                        height: 54
                        width: 80
                        btnIconSource: "qrc:/images/icons8-move-left-24.png"
                        btnColorDefault: "lightsteelblue"

                        onClicked: {
                            if (radiusTest.getText() === "" || zdownTest.getText() === ""){
                                return
                            }

                            calibrationControl.moveAPoint(radiusTest.getNumber(), zdownTest.getNumber())
                        }
                    }

                    LeftMenuButton {
                        btnText: "B"
                        height: 54
                        width: 80
                        btnIconSource: "qrc:/images/icons8-move-left-24.png"
                        btnColorDefault: "mediumaquamarine"

                        onClicked: {
                            if (radiusTest.getText() === "" || zdownTest.getText() === ""){
                                return
                            }

                            calibrationControl.moveBPoint(radiusTest.getNumber(), zdownTest.getNumber())
                        }
                    }

                    LeftMenuButton {
                        btnText: "C"
                        height: 54
                        width: 80
                        btnIconSource: "qrc:/images/icons8-move-left-24.png"
                        btnColorDefault: "tan"

                        onClicked: {
                            if (radiusTest.getText() === "" || zdownTest.getText() === ""){
                                return
                            }

                            calibrationControl.moveCPoint(radiusTest.getNumber(), zdownTest.getNumber())
                        }
                    }

                    CustomTextFieldNumber {
                        id: aTest
                        labelString: "A:"
                        width: 80
                    }

                    CustomTextFieldNumber {
                        id: bTest
                        labelString: "B:"
                        width: 80
                    }

                    CustomTextFieldNumber {
                        id: cTest
                        labelString: "C:"
                        width: 80
                    }
                }

            }

            Rectangle {
                id: homePositionPanel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: calculateKinematic.top
                anchors.bottomMargin: 16
                anchors.leftMargin: (internal.isVertical)?8:(parent.width/2)
                height: 56
                color: "transparent"

                //test
//                border.width: 1
//                border.color: "red"

                Text {
                    text: qsTr("Home Position")
                    font.pointSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: 26
                }

                LeftMenuButton {
                    id: adjustStepPer2PiBtn
                    anchors.verticalCenter: homePositionPanel.verticalCenter
                    anchors.left: grid2.right
                    btnText: "Setup"
                    btnIconSource: "qrc:/images/icons8-settings-32.png"
                    btnColorDefault: "hotpink"
                    height: 54
                    width: 96

                    onClicked: {
                        if (homeXTf.getText() === "" || homeYTf.getText() === "" || homeZTf.getText() === ""){
                            return
                        }

                        calibrationControl.setNewHomePosition(homeXTf.getNumber(), homeYTf.getNumber(), homeZTf.getNumber())
                    }
                }

                Grid {
                    id: grid2
                    anchors.fill: parent
                    anchors.topMargin: 26
                    anchors.rightMargin: 110
                    spacing: 6
                    columns: 3
                    rows: 1

                    CustomTextFieldNumber {
                        id: homeXTf
                        labelString: "X:"
                        width: 80
                    }

                    CustomTextFieldNumber {
                        id: homeYTf
                        labelString: "Y:"
                        width: 80
                    }

                    CustomTextFieldNumber {
                        id: homeZTf
                        labelString: "Z:"
                        width: 80
                    }
                }
            }

            Rectangle {
                id: calculateKinematic
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 85
                color: "transparent"
                anchors.leftMargin: (internal.isVertical)?8:(parent.width/2)
                anchors.bottomMargin: 10

                property bool most_recent_edit: false

                Text {
                    text: qsTr("Forward/Inverse Kinematic")
                    font.pointSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: 26
                }

                LeftMenuButton {
                    id: calculateBtn
                    anchors.verticalCenter: calculateKinematic.verticalCenter
                    anchors.left: grid1.right
                    btnText: "Convert"
                    btnIconSource: "qrc:/images/icons8-calculate-32.png"
                    btnColorDefault: "lightsalmon"
                    width: 96
                    height: 54
                    onClicked: {
                        console.log(item.width)
                        console.log(item.height)
                        if (calculateKinematic.most_recent_edit){
                            inverseCal()
                        }
                        else{
                            forwardCal()
                        }
                    }
                }

                Grid {
                    id: grid1
                    anchors.fill: parent
                    anchors.topMargin: 26
                    anchors.rightMargin: 110
                    spacing: 6
                    columns: 3
                    rows: 2

                    CustomTextFieldNumber {
                        id: t1Tf
                        labelString: "T1:"
                        width: 80
                        onTextEnter: {
                            forwardCal()
                        }
                        onTextFinish: {
                            calculateKinematic.most_recent_edit = false
                        }
                    }

                    CustomTextFieldNumber {
                        id: t2Tf
                        labelString: "T2:"
                        width: 80
                        onTextEnter: {
                            forwardCal()
                        }
                        onTextFinish: {
                            calculateKinematic.most_recent_edit = false
                        }
                    }

                    CustomTextFieldNumber {
                        id: t3Tf
                        labelString: "T3:"
                        width: 80
                        onTextEnter: {
                            forwardCal()
                        }
                        onTextFinish: {
                            calculateKinematic.most_recent_edit = false
                        }
                    }

                    CustomTextFieldNumber {
                        id: xTf
                        labelString: "X:"
                        width: 80
                        onTextEnter: {
                            inverseCal()
                        }
                        onTextFinish: {
                            calculateKinematic.most_recent_edit = true
                        }
                    }

                    CustomTextFieldNumber {
                        id: yTf
                        labelString: "Y:"
                        width: 80
                        onTextEnter: {
                            inverseCal()
                        }
                        onTextFinish: {
                            calculateKinematic.most_recent_edit = true
                        }
                    }

                    CustomTextFieldNumber {
                        id: zTf
                        labelString: "Z:"
                        width: 80
                        onTextEnter: {
                            inverseCal()
                        }
                        onTextFinish: {
                            calculateKinematic.most_recent_edit = true
                        }
                    }
                }
            }
        }
    }
}

