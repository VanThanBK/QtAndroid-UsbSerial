import QtQuick
import QtQuick.Controls
import "../controls"

Item {
    implicitHeight: 600
    implicitWidth: 400

    signal robotModelChanged(string _model_name)

    Component.onCompleted: {
        robotModelNameCbb.clearList()
        robotModelNameCbb.addElement("DELTA_XS_V5_D400")
        robotModelNameCbb.addElement("DELTA_XS_V5_D600")
        robotModelNameCbb.addElement("DELTA_XS_V5_D800")

        robotNumberAxisCbb.clearList()
        robotNumberAxisCbb.addElement("3AXIS")
        robotNumberAxisCbb.addElement("4AXIS")
        robotNumberAxisCbb.addElement("5AXIS")
        robotNumberAxisCbb.addElement("6AXIS")

        //robotParameter.createSuggestions()
        robotOFtf.setLimit(0, 500)
        robotFtf.setLimit(50, 1000)
        robotEtf.setLimit(10, 500)
        robotRFtf.setLimit(50, 600)
        robotREtf.setLimit(100, 1500)

        homeAngle1tf.setLimit(-50, 0)
        homeAngle2tf.setLimit(-50, 0)
        homeAngle3tf.setLimit(-50, 0)

        step1tf.setLimit(1000, 50000)
        step2tf.setLimit(1000, 50000)
        step3tf.setLimit(1000, 50000)

        homeSpeed4tf.setLimit(1, 200)
        homeRevert4tf.setLimit(1, 300)
        stepsPerUnit4tf.setLimit(0, 500)
        maxPosition4tf.setLimit(-1200, 1200)
        minPosition4tf.setLimit(-1200, 1200)
        homePosition4tf.setLimit(-361, 361)
        maxJer4tf.setLimit(100, 9000000)
        maxVel4tf.setLimit(100, 9000)
        maxAcc4tf.setLimit(100, 999999)

        homeSpeed5tf.setLimit(1, 200)
        homeRevert5tf.setLimit(1, 300)
        stepsPerUnit5tf.setLimit(0, 500)
        maxPosition5tf.setLimit(-1200, 1200)
        minPosition5tf.setLimit(-1200, 1200)
        homePosition5tf.setLimit(-361, 361)
        maxJer5tf.setLimit(100, 9000000)
        maxVel5tf.setLimit(100, 9000)
        maxAcc5tf.setLimit(100, 999999)

        homeSpeed6tf.setLimit(1, 200)
        homeRevert6tf.setLimit(1, 300)
        stepsPerUnit6tf.setLimit(0, 500)
        maxPosition6tf.setLimit(-1200, 1200)
        minPosition6tf.setLimit(-1200, 1200)
        homePosition6tf.setLimit(-361, 361)
        maxJer6tf.setLimit(100, 9000000)
        maxVel6tf.setLimit(100, 9000)
        maxAcc6tf.setLimit(100, 999999)
    }

    Connections {
        target: robotParameterControl
        function onUpdatedRobotModel(_robot_version, _robot_size, _robot_axis){

            var robot_model_name = "DELTA_XS_V5_D";
            robot_model_name += _robot_size.toString();
            robotModelNameCbb.setText(robot_model_name);

            var robot_axis_number = "AXIS";
            robot_axis_number = _robot_axis.toString() + robot_axis_number;
            robotNumberAxisCbb.setText(robot_axis_number);

            if (suggestionsSwitch.checked){
                getSuggestions()
            }
        }
        function onUpdatedRobotImei(_robot_imei){
            robotImeiCtf.setText(_robot_imei)
        }
        function onUpdatedRobotGeometry(_of, _f, _e, _rf, _re){
            _of = _of.toFixed(2);
            _f = _f.toFixed(2);
            _e = _e.toFixed(2);
            _rf = _rf.toFixed(2);
            _re = _re.toFixed(2);

            robotOFtf.setText(_of.toString())
            robotFtf.setText(_f.toString())
            robotEtf.setText(_e.toString())
            robotRFtf.setText(_rf.toString())
            robotREtf.setText(_re.toString())
        }
        function onUpdatedRobotMaxSize(_z, _d){
            _z = _z.toFixed(2);
            _d = _d.toFixed(2);

            robotZtf.setNumber(_z)
            robotDtf.setNumber(_d)
        }

        function onUpdatedRobotHomeAngle(t1, t2, t3){
            t1 = t1.toFixed(3);
            t2 = t2.toFixed(3);
            t3 = t3.toFixed(3);

            homeAngle1tf.setText(t1)
            homeAngle2tf.setText(t2)
            homeAngle3tf.setText(t3)
        }
        function onUpdatedRobotStepPer2Pi(t1, t2, t3){
            t1 = t1.toFixed(0);
            t2 = t2.toFixed(0);
            t3 = t3.toFixed(0);

            step1tf.setText(t1)
            step2tf.setText(t2)
            step3tf.setText(t3)
        }

        function onNewNotification(_is_done, _noti){
            messageDialog.showNote(_is_done, _noti)
        }
        function onUpdatedRobotAxis4Infor(_list_bool, _list_float){
            endStopEnable4cs.checked = _list_bool[1]
            endStopInvert4cs.checked = _list_bool[2]

            homeSpeed4tf.setNumber(_list_float[0])
            homeRevert4tf.setNumber(_list_float[1])
            stepsPerUnit4tf.setNumber(_list_float[2].toFixed(6))
            maxPosition4tf.setNumber(_list_float[3])
            minPosition4tf.setNumber(_list_float[4])
            homePosition4tf.setNumber(_list_float[5])
            maxAcc4tf.setNumber(_list_float[6])
            maxJer4tf.setNumber(_list_float[7])
            maxVel4tf.setNumber(_list_float[8])
        }
        function onUpdatedRobotAxis5Infor(_list_bool, _list_float){
            endStopEnable5cs.checked = _list_bool[1]
            endStopInvert5cs.checked = _list_bool[2]

            homeSpeed5tf.setNumber(_list_float[0])
            homeRevert5tf.setNumber(_list_float[1])
            stepsPerUnit5tf.setNumber(_list_float[2].toFixed(6))
            maxPosition5tf.setNumber(_list_float[3])
            minPosition5tf.setNumber(_list_float[4])
            homePosition5tf.setNumber(_list_float[5])
            maxAcc5tf.setNumber(_list_float[6])
            maxJer5tf.setNumber(_list_float[7])
            maxVel5tf.setNumber(_list_float[8])
        }
        function onUpdatedRobotAxis6Infor(_list_bool, _list_float){
            endStopEnable6cs.checked = _list_bool[1]
            endStopInvert6cs.checked = _list_bool[2]

            homeSpeed6tf.setNumber(_list_float[0])
            homeRevert6tf.setNumber(_list_float[1])
            stepsPerUnit6tf.setNumber(_list_float[2].toFixed(6))
            maxPosition6tf.setNumber(_list_float[3])
            minPosition6tf.setNumber(_list_float[4])
            homePosition6tf.setNumber(_list_float[5])
            maxAcc6tf.setNumber(_list_float[6])
            maxJer6tf.setNumber(_list_float[7])
            maxVel6tf.setNumber(_list_float[8])
        }
    }

    function getSuggestions(){
        var _robot_size = 0;
        var _robot_string = robotModelNameCbb.getText()
        _robot_size = parseInt(_robot_string.slice(_robot_string.length - 3, _robot_string.length))

        var _robot_axis = 3;
        _robot_string = robotNumberAxisCbb.getText()
        _robot_axis = parseInt(_robot_string.slice(0, 1))

        robotParameterControl.getRobotSuggestions(5, _robot_size, _robot_axis)
    }

    function saveAllData(){
        if (robotOFtf.getText() === "" || robotFtf.getText() === "" || robotREtf.getText() === ""
                || robotEtf.getText() === "" || robotRFtf.getText() === ""){
            messageDialog.showNote(false, "Error: empty data!")
            return
        }
        if (robotZtf.getText() === "" || robotDtf.getText() === ""){
            messageDialog.showNote(false, "Error: empty data!")
            return
        }
        if (homeAngle1tf.getText() === "" || homeAngle2tf.getText() === "" || homeAngle3tf.getText() === ""){
            messageDialog.showNote(false, "Error: empty data!")
            return
        }
        if (step1tf.getText() === "" || step2tf.getText() === "" || step3tf.getText() === ""){
            messageDialog.showNote(false, "Error: empty data!")
            return
        }

        var _robot_axis = 3;
        var _robot_string = robotNumberAxisCbb.getText()
        _robot_axis = parseInt(_robot_string.slice(0, 1))

        if (_robot_axis > 3){
            if (homeSpeed4tf.getText() === "" || homeRevert4tf.getText() === "" || stepsPerUnit4tf.getText() === "" ||
                maxPosition4tf.getText() === "" || minPosition4tf.getText() === "" || homePosition4tf.getText() === "" ||
                maxJer4tf.getText() === "" || maxVel4tf.getText() === "" || maxAcc4tf.getText() === ""){
                messageDialog.showNote(false, "Error: empty data!")
                return
            }
        }
        if (_robot_axis > 4){
            if (homeSpeed5tf.getText() === "" || homeRevert5tf.getText() === "" || stepsPerUnit5tf.getText() === "" ||
                maxPosition5tf.getText() === "" || minPosition5tf.getText() === "" || homePosition5tf.getText() === "" ||
                maxJer5tf.getText() === "" || maxVel5tf.getText() === "" || maxAcc5tf.getText() === ""){
                messageDialog.showNote(false, "Error: empty data!")
                return
            }
        }

        if (_robot_axis > 5){
            if (homeSpeed6tf.getText() === "" || homeRevert6tf.getText() === "" || stepsPerUnit6tf.getText() === "" ||
                maxPosition6tf.getText() === "" || minPosition6tf.getText() === "" || homePosition6tf.getText() === "" ||
                maxJer6tf.getText() === "" || maxVel6tf.getText() === "" || maxAcc6tf.getText() === ""){
                messageDialog.showNote(false, "Error: empty data!")
                return
            }
        }

        robotParameterControl.setRobotGeometry(robotOFtf.getNumber(), robotFtf.getNumber(), robotEtf.getNumber(),
                                               robotRFtf.getNumber(), robotREtf.getNumber())

        robotParameterControl.setRobotMaxSize(robotZtf.getNumber(), robotDtf.getNumber())

        robotParameterControl.setRobotHomeAngle(homeAngle1tf.getNumber(), homeAngle2tf.getNumber(), homeAngle3tf.getNumber())

        robotParameterControl.setRobotStepPer2Pi(step1tf.getNumber(), step2tf.getNumber(), step3tf.getNumber())

        if (_robot_axis > 3){
            var _list_bool = []
            _list_bool.push(true)
            _list_bool.push(endStopEnable4cs.checked)
            _list_bool.push(endStopInvert4cs.checked)
            var _list_float = []
            _list_float.push(homeSpeed4tf.getNumber())
            _list_float.push(homeRevert4tf.getNumber())
            _list_float.push(stepsPerUnit4tf.getNumber())
            _list_float.push(maxPosition4tf.getNumber())
            _list_float.push(minPosition4tf.getNumber())
            _list_float.push(homePosition4tf.getNumber())
            _list_float.push(maxAcc4tf.getNumber())
            _list_float.push(maxJer4tf.getNumber())
            _list_float.push(maxVel4tf.getNumber())

            robotParameterControl.setRobotAxis4Infor(_list_bool, _list_float)
        }

        if (_robot_axis > 4){
            _list_bool = []
            _list_bool.push(true)
            _list_bool.push(endStopEnable5cs.checked)
            _list_bool.push(endStopInvert5cs.checked)
            _list_float = []
            _list_float.push(homeSpeed5tf.getNumber())
            _list_float.push(homeRevert5tf.getNumber())
            _list_float.push(stepsPerUnit5tf.getNumber())
            _list_float.push(maxPosition5tf.getNumber())
            _list_float.push(minPosition5tf.getNumber())
            _list_float.push(homePosition5tf.getNumber())
            _list_float.push(maxAcc5tf.getNumber())
            _list_float.push(maxJer5tf.getNumber())
            _list_float.push(maxVel5tf.getNumber())

            robotParameterControl.setRobotAxis5Infor(_list_bool, _list_float)
        }

        if (_robot_axis > 5){
            _list_bool = []
            _list_bool.push(true)
            _list_bool.push(endStopEnable6cs.checked)
            _list_bool.push(endStopInvert6cs.checked)
            _list_float = []
            _list_float.push(homeSpeed6tf.getNumber())
            _list_float.push(homeRevert6tf.getNumber())
            _list_float.push(stepsPerUnit6tf.getNumber())
            _list_float.push(maxPosition6tf.getNumber())
            _list_float.push(minPosition6tf.getNumber())
            _list_float.push(homePosition6tf.getNumber())
            _list_float.push(maxAcc6tf.getNumber())
            _list_float.push(maxJer6tf.getNumber())
            _list_float.push(maxVel6tf.getNumber())

            robotParameterControl.setRobotAxis6Infor(_list_bool, _list_float)
        }

        robotParameterControl.uploadParameterToRobot()
    }

    CustomMessageDialog {
        id: messageDialog

    }

    CustomComboBox {
        id: robotModelNameCbb
        labelString: "Model:"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.topMargin: 6
        width: 190
        height: 26

        onIndexChanged: {
            var _model_name = robotModelNameCbb.getText();
            //robotView3D.setModelName(_model_name.toLowerCase())
            robotModelChanged(_model_name)
            if (suggestionsSwitch.checked){
                getSuggestions()
            }
        }
    }

    CustomComboBox {
        id: robotNumberAxisCbb
        labelString: ""
        anchors.verticalCenter: robotModelNameCbb.verticalCenter
        anchors.left: robotModelNameCbb.right
        width: 80
        height: 26

        onIndexChanged: {
            var _robot_axis = 3;
            var _robot_string = robotNumberAxisCbb.getText()

            if (typeof(_robot_string) == "undefined") {
                return
            }

            _robot_axis = parseInt(_robot_string.slice(0, 1))

            if (_robot_axis < 6){
                axis6Gb.height = 20;
            }
            if (_robot_axis < 5){
                axis5Gb.height = 20;
            }
            if (_robot_axis < 4){
                axis4Gb.height = 20;
            }
        }
    }

    CustomTextField {
        id: robotImeiCtf
        labelString: "IMEI:"
        anchors.left: parent.left
        anchors.leftMargin: 10
        height: 26
        width: 170
        anchors.top: robotModelNameCbb.bottom
        anchors.topMargin: 8
    }

    LeftMenuButton {
        anchors.verticalCenter: robotNumberAxisCbb.verticalCenter
        anchors.left: robotNumberAxisCbb.right
        anchors.leftMargin: 6
        btnText: "Change"
        height: 26
        width: 88
        btnColorDefault: "deepskyblue"
        btnIconSource: "qrc:/images/icons8-change-30.png"

        onClicked: {
            var _robot_size = 0;
            var _robot_string = robotModelNameCbb.getText()
            _robot_size = parseInt(_robot_string.slice(_robot_string.length - 3, _robot_string.length))

            var _robot_axis = 3;
            _robot_string = robotNumberAxisCbb.getText()
            _robot_axis = parseInt(_robot_string.slice(0, 1))

            robotParameterControl.setRobotModel(5, _robot_size, _robot_axis)

            if (robotImeiCtf.getText() === ""){
                messageDialog.showNote(false, "Error: empty data!")
                return;
            }

            robotParameterControl.setRobotImei(robotImeiCtf.getText())

            robotParameterControl.uploadInforToRobot()
        }
    }

    GroupBox {
        id: kinematicParametersGb
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: robotImeiCtf.bottom
        anchors.rightMargin: 4
        anchors.leftMargin: 4
        anchors.topMargin: 10
        height: 95
        font.pointSize: 10
        title: "Kinematic Parameters"

        Flow {
            anchors.fill: parent
//            anchors.topMargin: 10
            spacing: 6
//            columns: 4
//            rows: 2

            CustomTextFieldNumber {
                id: robotOFtf
                labelString: "OF:"
                height: 26
                width: 86
            }

            CustomTextFieldNumber {
                id: robotFtf
                labelString: "F:"
                height: 26
                width: 80
            }

            CustomTextFieldNumber {
                id: robotEtf
                labelString: "E:"
                height: 26
                width: 80
            }

            CustomTextFieldNumber {
                id: robotRFtf
                labelString: "RF:"
                height: 26
                width: 86
            }

            CustomTextFieldNumber {
                id: robotREtf
                labelString: "RE:"
                height: 26
                width: 100
            }

            CustomTextFieldNumber {
                id: robotZtf
                labelString: "Z:"
                height: 26
                width: 100
            }

            CustomTextFieldNumber {
                id: robotDtf
                labelString: "D:"
                height: 26
                width: 100
            }
        }
    }

    GroupBox {
        id: homeAngleGb
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: kinematicParametersGb.bottom
        anchors.rightMargin: 4
        anchors.leftMargin: 4
        anchors.topMargin: 10
        height: 60
        font.pointSize: 10
        title: "Home Angle"

        Grid {
            anchors.fill: parent
//            anchors.topMargin: 10
            spacing: 12
            columns: 3
            rows: 1

            CustomTextFieldNumber {
                id: homeAngle1tf
                labelString: "T1:"
                height: 26
                width: 100
            }

            CustomTextFieldNumber {
                id: homeAngle2tf
                labelString: "T2:"
                height: 26
                width: 100
            }

            CustomTextFieldNumber {
                id: homeAngle3tf
                labelString: "T3:"
                height: 26
                width: 100
            }
        }
    }

    GroupBox {
        id: stepPer2PiGb
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: homeAngleGb.bottom
        anchors.rightMargin: 4
        anchors.leftMargin: 4
        anchors.topMargin: 10
        height: 60
        font.pointSize: 10
        title: "Step Per 2Pi"

        Grid {
            anchors.fill: parent
//            anchors.topMargin: 10
            spacing: 12
            columns: 3
            rows: 1

            CustomTextFieldNumber {
                id: step1tf
                labelString: "T1:"
                height: 26
                width: 100
            }

            CustomTextFieldNumber {
                id: step2tf
                labelString: "T2:"
                height: 26
                width: 100
            }

            CustomTextFieldNumber {
                id: step3tf
                labelString: "T3:"
                height: 26
                width: 100
            }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 4
        anchors.leftMargin: 4
        anchors.top: stepPer2PiGb.bottom
        anchors.topMargin: 10
        anchors.bottom: reloadParametersBtn.top
        anchors.bottomMargin: 10
        clip: true

        ScrollBar {
            id: vbar
            hoverEnabled: true
            active: hovered || pressed
            orientation: Qt.Vertical
            size: parent.height / axisborderRct.height
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            policy: ScrollBar.AlwaysOn
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.MiddleButton
            onWheel: {
                if (!wheel) {
                    return
                }
                if (wheel.angleDelta.y < 0){
                    vbar.increase()
                }
                else if (wheel.angleDelta.y > 0){
                    vbar.decrease()
                }
            }
        }

    Rectangle {
        id: axisborderRct
        anchors.left: parent.left
        anchors.right: parent.right
        height: axis4Gb.height + axis5Gb.height + axis6Gb.height + 20
        anchors.rightMargin: vbar.width
        y: -vbar.position * (height)

    GroupBox {
        id: axis4Gb
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        height: 20
        font.pointSize: 10
        title: "AXIS 4"
        clip: true

        enabled: (robotNumberAxisCbb.getText() === "3AXIS")?false:true

        label: Item {
            Label {
                id: name
                text: qsTr("AXIS 4 CONFIG")
                font.pointSize: 10
                anchors.left: parent.left
                anchors.leftMargin: 7
                background: Rectangle {
                    color: "#d6d6d6"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (axis4Gb.height > 100){
                            axis4Gb.height = 20
                        }
                        else{
                            axis4Gb.height = 150
                        }
                    }
                }
            }
        }

        Flow {
            id: flow1
            anchors.fill: parent
//            anchors.topMargin: 10
            spacing: 6
//            columns: 3
//            rows: 4

            CustomSwitch {
                id: endStopEnable4cs
                text: "EndStop"
                height: 20
                width: 100
            }

            CustomSwitch {
                id: endStopInvert4cs
                text: "ES Invert"
                height: 20
                width: 110
            }

            CustomTextFieldNumber {
                id: homeSpeed4tf
                labelString: "HomeSpeed:"
                height: 24
                width: 130
            }

            CustomTextFieldNumber {
                id: homeRevert4tf
                labelString: "HomeRevert:"
                height: 24
                width: 130
            }

            CustomTextFieldNumber {
                id: stepsPerUnit4tf
                labelString: "StepsPerUnit:"
                height: 24
                width: 180
            }

            CustomTextFieldNumber {
                id: maxPosition4tf
                labelString: "MaxPos:"
                height: 24
                width: 110
            }

            CustomTextFieldNumber {
                id: minPosition4tf
                labelString: "MinPos:"
                height: 24
                width: 110
            }

            CustomTextFieldNumber {
                id: homePosition4tf
                labelString: "HomePos:"
                height: 24
                width: 120
            }

            CustomTextFieldNumber {
                id: maxJer4tf
                labelString: "MaxJer:"
                height: 24
                width: 124
            }

            CustomTextFieldNumber {
                id: maxVel4tf
                labelString: "MaxVel:"
                height: 24
                width: 104
            }

            CustomTextFieldNumber {
                id: maxAcc4tf
                labelString: "MaxAcc:"
                height: 24
                width: 114
            }
        }
    }

    GroupBox {
        id: axis5Gb
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: axis4Gb.bottom
        anchors.topMargin: 10
        height: 20
        font.pointSize: 10
        title: "AXIS 5"
        clip: true

        enabled: (robotNumberAxisCbb.getText() === "5AXIS" || robotNumberAxisCbb.getText() === "6AXIS")?true:false

        label: Item {
            Label {
                text: qsTr("AXIS 5 CONFIG")
                font.pointSize: 10
                anchors.left: parent.left
                anchors.leftMargin: 7
                background: Rectangle {
                    color: "#d6d6d6"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (axis5Gb.height > 100){
                            axis5Gb.height = 20
                        }
                        else{
                            axis5Gb.height = 150
                        }
                    }
                }
            }
        }

        Flow {
            anchors.fill: parent
//            anchors.topMargin: 10
            spacing: 6
//            columns: 3
//            rows: 4

            CustomSwitch {
                id: endStopEnable5cs
                text: "EndStop"
                height: 20
                width: 100
            }

            CustomSwitch {
                id: endStopInvert5cs
                text: "ES Invert"
                height: 20
                width: 110
            }

            CustomTextFieldNumber {
                id: homeSpeed5tf
                labelString: "HomeSpeed:"
                height: 24
                width: 130
            }

            CustomTextFieldNumber {
                id: homeRevert5tf
                labelString: "HomeRevert:"
                height: 24
                width: 130
            }

            CustomTextFieldNumber {
                id: stepsPerUnit5tf
                labelString: "StepsPerUnit:"
                height: 24
                width: 180
            }

            CustomTextFieldNumber {
                id: maxPosition5tf
                labelString: "MaxPos:"
                height: 24
                width: 110
            }

            CustomTextFieldNumber {
                id: minPosition5tf
                labelString: "MinPos:"
                height: 24
                width: 110
            }

            CustomTextFieldNumber {
                id: homePosition5tf
                labelString: "HomePos:"
                height: 24
                width: 120
            }

            CustomTextFieldNumber {
                id: maxJer5tf
                labelString: "MaxJer:"
                height: 24
                width: 124
            }

            CustomTextFieldNumber {
                id: maxVel5tf
                labelString: "MaxVel:"
                height: 24
                width: 104
            }

            CustomTextFieldNumber {
                id: maxAcc5tf
                labelString: "MaxAcc:"
                height: 24
                width: 114
            }
        }
    }

    GroupBox {
        id: axis6Gb
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: axis5Gb.bottom
        anchors.topMargin: 10
        height: 20
        font.pointSize: 10
        title: "AXIS 6"
        clip: true

        enabled: (robotNumberAxisCbb.getText() === "6AXIS")?true:false

        label: Item {
            Label {
                text: qsTr("AXIS 6 CONFIG")
                font.pointSize: 10
                anchors.left: parent.left
                anchors.leftMargin: 7
                background: Rectangle {
                    color: "#d6d6d6"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (axis6Gb.height > 100){
                            axis6Gb.height = 20
                        }
                        else{
                            axis6Gb.height = 150
                        }
                    }
                }
            }
        }

        Flow {
            anchors.fill: parent
//            anchors.topMargin: 10
            spacing: 6
//            columns: 3
//            rows: 4

            CustomSwitch {
                id: endStopEnable6cs
                text: "EndStop"
                height: 20
                width: 100
            }

            CustomSwitch {
                id: endStopInvert6cs
                text: "ES Invert"
                height: 20
                width: 110
            }

            CustomTextFieldNumber {
                id: homeSpeed6tf
                labelString: "HomeSpeed:"
                height: 24
                width: 130
            }

            CustomTextFieldNumber {
                id: homeRevert6tf
                labelString: "HomeRevert:"
                height: 24
                width: 130
            }

            CustomTextFieldNumber {
                id: stepsPerUnit6tf
                labelString: "StepsPerUnit:"
                height: 24
                width: 180
            }

            CustomTextFieldNumber {
                id: maxPosition6tf
                labelString: "MaxPos:"
                height: 24
                width: 110
            }

            CustomTextFieldNumber {
                id: minPosition6tf
                labelString: "MinPos:"
                height: 24
                width: 110
            }

            CustomTextFieldNumber {
                id: homePosition6tf
                labelString: "HomePos:"
                height: 24
                width: 120
            }

            CustomTextFieldNumber {
                id: maxJer6tf
                labelString: "MaxJer:"
                height: 24
                width: 124
            }

            CustomTextFieldNumber {
                id: maxVel6tf
                labelString: "MaxVel:"
                height: 24
                width: 104
            }

            CustomTextFieldNumber {
                id: maxAcc6tf
                labelString: "MaxAcc:"
                height: 24
                width: 114
            }
        }
    }
    }
    }

    CustomSwitch {
        id: suggestionsSwitch
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        text: "Suggestions"
        height: 20
        font.pointSize: 10
        onCheckedChanged: {
            if (checked){
                getSuggestions()
            }
        }
    }

    LeftMenuButton {
        id: reloadParametersBtn
        anchors.verticalCenter: suggestionsSwitch.verticalCenter
        btnText: "Reload"
        anchors.right: saveParametersBtn.left
        anchors.rightMargin: 6
        btnIconSource: "qrc:/images/icons8-down-30.png"
        btnColorDefault: "papayawhip"
        width: 95
        onClicked: {
            robotParameterControl.getRobotParameter();
        }
    }

    LeftMenuButton {
        id: saveParametersBtn
        anchors.verticalCenter: suggestionsSwitch.verticalCenter
        btnText: "Save"
        anchors.right: parent.right
        anchors.rightMargin: 6
        btnIconSource: "qrc:/images/icons8-save-30.png"
        btnColorDefault: "lightgreen"
        width: 95
        onClicked: {
            saveAllData()
        }
    }
}
