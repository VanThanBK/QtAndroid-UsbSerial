import QtQuick
import QtQuick.Controls
import QtCharts

Item {
    implicitWidth: 1000
    implicitHeight: 420

    property color desire_dis_color: "#7b241c"
    property color desire_vel_color: "#633974"
    property color desire_acc_color: "#1a5276"
    property color desire_jer_color: "#196f3d"
    property color real_dis_color: "#e74c3c"
    property color real_vel_color: "#8e44aa"
    property color real_acc_color: "#3498db"
    property color real_jer_color: "#2ecc71"

    Connections {
        target: movementChecker
        function onAddNewDesireScurveData(_p, _v, _a, _j, _t){
            addNewDesireScurvePoint(_p, _v, _a, _j, _t)
        }
    }

    Component.onCompleted: {
        scaleJerCbb.clearList()
        scaleJerCbb.addElement("x10")
        scaleJerCbb.addElement("/10")
        scaleJerCbb.addElement("/50")
        scaleJerCbb.addElement("/100")
        scaleJerCbb.addElement("/200")
        scaleJerCbb.addElement("/500")
        scaleJerCbb.addElement("/1000")
        scaleJerCbb.addElement("/1500")
        scaleJerCbb.addElement("/2000")
        scaleJerCbb.addElement("/2500")
        scaleJerCbb.addElement("/3000")
        scaleJerCbb.setText("/1000")

        scaleAccCbb.clearList()
        scaleAccCbb.addElement("x50")
        scaleAccCbb.addElement("x10")
        scaleAccCbb.addElement("x1")
        scaleAccCbb.addElement("/10")
        scaleAccCbb.addElement("/50")
        scaleAccCbb.addElement("/100")
        scaleAccCbb.addElement("/200")
        scaleAccCbb.addElement("/500")
        scaleAccCbb.addElement("/1000")
        scaleAccCbb.setText("/10")

        samplesCbb.clearList()
        samplesCbb.addElement("1.2")
        samplesCbb.addElement("2.4")
        samplesCbb.addElement("3.6")
        samplesCbb.addElement("4.8")
        samplesCbb.addElement("6.0")
        samplesCbb.addElement("7.2")
        samplesCbb.addElement("8.4")
        samplesCbb.addElement("9.6")
        samplesCbb.setText("1.2")

        lineShowCbb.clearList()
        for (var index = 0; index < scurveCV.count; index++){
            lineShowCbb.addElement(scurveCV.series(index).name, scurveCV.series(index).visible)
            scurveCV.series(index).width = 2
        }

        movementChecker.clearDesireScurveArray()
    }

    function addNewDesireScurvePoint(p, v, a, j, t)
    {
        if (!desireScurveEnable.checked){
            return
        }

        p = p.toFixed(2)
        v = v.toFixed(2)
        a = (a * getScaleAcc()).toFixed(2)
        j = (j * getScaleJer()).toFixed(2)
        t = t.toFixed(2)

        desire_d.append(t, p)
        desire_v.append(t, v)
        desire_a.append(t, a)
        desire_j.append(t, j)

        valueAxisX.max = t + 2
        valueAxisY.max = Math.max(valueAxisY.max, p + 20, v + 20, a + 20, j + 20)
        valueAxisY.min = Math.min(valueAxisY.min, p - 20, v - 20, a - 20, j - 20)
    }

    function addNewRealScurvePoint(p, v, a, j, t)
    {
        if (!realScurveEnable.checked){
            return
        }

        p = p.toFixed(2);
        v = v.toFixed(2);
        a = a.toFixed(2);
        j = j.toFixed(2);
        t = t.toFixed(2);

        real_d.append(t, p);
        real_v.append(t, v);
        real_a.append(t, a * getScaleAcc());
        real_j.append(t, j * getScaleJer());
    }

    function getScaleJer(){
        var _str = scaleJerCbb.getText();
        if (_str.startsWith("/")){
            _str = _str.replace('/','');
            return 1 / parseInt(_str)
        }
        else if (_str.startsWith("x")){
            _str = _str.replace('x','');
            return parseInt(_str)
        }
    }

    function getScaleAcc(){
        var _str = scaleAccCbb.getText();
        if (_str.startsWith("/")){
            _str = _str.replace('/','');
            return 1 / parseInt(_str)
        }
        else if (_str.startsWith("x")){
            _str = _str.replace('x','');
            return parseInt(_str)
        }
    }

    function getSamples(){
        return parseFloat(samplesCbb.getText())
    }

    function clearDesireLineSeries(){
        desire_d.clear()
        desire_v.clear()
        desire_a.clear()
        desire_j.clear()
        valueAxisX.max = 0
        valueAxisY.max = 0
        valueAxisY.min = 0
    }

    ChartView {
        id: scurveCV
        //title: "Scurve Charts"
        height: parent.height
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        antialiasing: true
        legend.visible: true
        legend.font.pointSize: 12
        legend.alignment: Qt.AlignBottom
        legend.markerShape: Legend.MarkerShapeCircle

        MouseArea {
            anchors.fill: parent
            anchors.bottomMargin: 120
            acceptedButtons: Qt.AllButtons
            property bool isPressing: false
            property int mouseButton: 0
            property int current_x: 0
            property int current_y: 0

            Rectangle {
                id: zoomRectDisplay
                visible: false
                border.width: 1
                transformOrigin: Item.TopLeft
                color: "transparent"
            }

            onPressed: {
                if (mouse.button === Qt.RightButton || mouse.button === Qt.MiddleButton) {
                    current_x = mouse.x
                    current_y = mouse.y
                    isPressing = true
                    mouseButton = mouse.button
                }
                if (mouse.button === Qt.MiddleButton) {
                    zoomRectDisplay.x = mouse.x
                    zoomRectDisplay.y = mouse.y
                    zoomRectDisplay.height = 0
                    zoomRectDisplay.width = 0
                    zoomRectDisplay.visible = true
                }
            }

            onPositionChanged: {
                if (isPressing == false){
                    return
                }

                var offset_x = mouse.x - current_x
                var offset_y = mouse.y - current_y

                if (mouseButton === Qt.RightButton) {
                    if (offset_x > 0){
                        scurveCV.scrollLeft(offset_x)
                    }
                    else{
                        scurveCV.scrollRight(Math.abs(offset_x))
                    }
                    if (offset_y > 0){
                        scurveCV.scrollUp(offset_y)
                    }
                    else{
                        scurveCV.scrollDown(Math.abs(offset_y))
                    }

                    current_x = mouse.x
                    current_y = mouse.y
                }
                else if (mouseButton === Qt.MiddleButton) {
                    if (offset_x >= 0 && offset_y >= 0){
                        zoomRectDisplay.rotation = 0;
                        zoomRectDisplay.width = Math.abs(offset_x)
                        zoomRectDisplay.height = Math.abs(offset_y)
                    }
                    else if (offset_x >= 0 && offset_y < 0){
                        zoomRectDisplay.rotation = 270;
                        zoomRectDisplay.width = Math.abs(offset_y)
                        zoomRectDisplay.height = Math.abs(offset_x)
                    }
                    else if (offset_x < 0 && offset_y < 0){
                        zoomRectDisplay.rotation = 180;
                        zoomRectDisplay.width = Math.abs(offset_x)
                        zoomRectDisplay.height = Math.abs(offset_y)
                    }
                    else if (offset_x < 0 && offset_y >= 0){
                        zoomRectDisplay.rotation = 90;
                        zoomRectDisplay.width = Math.abs(offset_y)
                        zoomRectDisplay.height = Math.abs(offset_x)
                    }
                }
            }

            onReleased: {
                if (mouse.button === Qt.RightButton || mouse.button === Qt.MiddleButton) {
                    isPressing = false
                }
                if (mouse.button === Qt.MiddleButton) {
                    zoomRectDisplay.visible = false
                    var offset_x = mouse.x - current_x
                    var offset_y = mouse.y - current_y
                    if (Math.abs(offset_x) > 30 && Math.abs(offset_y) > 30){
                        var x_rect = 0;
                        var y_rect = 0;
                        if (offset_x > 20){
                            x_rect = current_x
                        }
                        else{
                            x_rect = mouse.x
                        }

                        if (offset_y > 20){
                            y_rect = current_y
                        }
                        else{
                            y_rect = mouse.y
                        }
                        scurveCV.zoomIn(Qt.rect(x_rect, y_rect, Math.abs(offset_x), Math.abs(offset_y)))
                    }
                }
            }

            onWheel: {
                if (!wheel) {
                    return
                }
                if (wheel.angleDelta.y > 0){
                    scurveCV.zoomIn();
                }
                else if (wheel.angleDelta.y < 0){
                    scurveCV.zoomOut();
                }
            }

            onDoubleClicked: {
                if (mouse.button === Qt.MiddleButton){
                    scurveCV.zoomReset()
                }
            }
        }

        ValuesAxis {
            id: valueAxisX
            titleText: "time [ms]"
            min: 0
        }

        ValuesAxis {
            id: valueAxisY
            titleText: "value [mm/t^n]"
            min: -10
        }

        LineSeries {
            id: desire_d
            name: "desire_dis "
            color: desire_dis_color
            axisX: valueAxisX
            axisY: valueAxisY
            onHovered: {
                mouseHoverTime.text = point.x.toFixed(2).toString() + " (ms)"
                mouseHoverValue.text = point.y.toFixed(2).toString() + " (mm/t^n)"
            }
        }

        LineSeries {
            id: desire_v
            name: "desire_vel "
            color: desire_vel_color
            onHovered: {
                mouseHoverTime.text = point.x.toFixed(2).toString() + " (ms)"
                mouseHoverValue.text = point.y.toFixed(2).toString() + " (mm/t^n)"
            }
        }

        LineSeries {
            id: desire_a
            name: "desire_acc "
            color: desire_acc_color
            onHovered: {
                mouseHoverTime.text = point.x.toFixed(2).toString() + " (ms)"
                mouseHoverValue.text = (point.y / getScaleAcc()).toFixed(2).toString() + " (mm/t^n)"
            }
        }

        LineSeries {
            id: desire_j
            name: "desire_jer "
            color: desire_jer_color
            onHovered: {
                mouseHoverTime.text = point.x.toFixed(2).toString() + " (ms)"
                mouseHoverValue.text = (point.y / getScaleJer()).toFixed(2).toString() + " (mm/t^n)"
            }
        }

        LineSeries {
            id: real_d
            name: "real_dis "
            color: real_dis_color
            onHovered: {
                mouseHoverTime.text = point.x.toFixed(2).toString() + " (ms)"
                mouseHoverValue.text = point.y.toFixed(2).toString() + " (mm/t^n)"
            }
        }

        LineSeries {
            id: real_v
            name: "real_vel "
            color: real_vel_color
            onHovered: {
                mouseHoverTime.text = point.x.toFixed(2).toString() + " (ms)"
                mouseHoverValue.text = point.y.toFixed(2).toString() + " (mm/t^n)"
            }
        }

        LineSeries {
            id: real_a
            name: "real_acc "
            color: real_acc_color
            onHovered: {
                mouseHoverTime.text = point.x.toFixed(2).toString() + " (ms)"
                mouseHoverValue.text = (point.y / getScaleAcc()).toFixed(2).toString() + " (mm/t^n)"
            }
        }

        LineSeries {
            id: real_j
            name: "real_jer "
            color: real_jer_color
            onHovered: {
                mouseHoverTime.text = point.x.toFixed(2).toString() + " (ms)"
                mouseHoverValue.text = (point.y / getScaleJer()).toFixed(2).toString() + " (mm/t^n)"
            }
        }

        CustomComboBox {
            id: scaleJerCbb
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 16
            height: 24
            width: 120
            anchors.right: parent.right
            anchors.rightMargin: 20
            labelString: "Scale Jer:"
            //colorBorder: "transparent"

            onIndexChanged: {
                clearDesireLineSeries()
                movementChecker.reloadDesireScurve()
            }
        }

        CustomComboBox {
            id: scaleAccCbb
            anchors.bottom: scaleJerCbb.top
            height: 24
            width: 120
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottomMargin: 4
            labelString: "Scale Acc:"
            //colorBorder: "transparent"

            onIndexChanged: {
                clearDesireLineSeries()
                movementChecker.reloadDesireScurve()
            }
        }

        CustomComboBox {
            id: samplesCbb
            anchors.bottom: scaleAccCbb.top
            height: 24
            width: 130
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottomMargin: 4
            labelString: "Samples(ms):"
            //colorBorder: "transparent"
        }

        ComboBoxWithCheckBox {
            id: lineShowCbb
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 16

            onSelectedChanged: {
                for (var index = 0; index < scurveCV.count; index++){
                    if (scurveCV.series(index).name === model_name){
                        scurveCV.series(index).visible = ischecked
                        break
                    }
                }
            }
        }

        CustomSwitch {
            id: desireScurveEnable
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.bottom: lineShowCbb.top
            font.pointSize: 10
            anchors.bottomMargin: 4
            text: "Desire"
            height: 20
            width: 100
            onCheckedChanged: {
                if (checked){
                    if (!movementChecker.turnOnDesireScurve(getSamples()))
                    {
                        checked = false
                    }
                }
                else{
                    movementChecker.turnOffDesireScurve()
                }
            }
        }

        CustomSwitch {
            id: realScurveEnable
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.bottom: desireScurveEnable.top
            anchors.bottomMargin: 4
            text: "Real"
            font.pointSize: 10
            height: 20
            width: 100

            onCheckedChanged: {

            }
        }

        TopBarButton {
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            btnColorDefault: "azure"

            onClicked: {
                clearDesireLineSeries()
                movementChecker.clearDesireScurveArray()
            }
        }

        Text {
            id: mouseHoverTime
            anchors.top: parent.top
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 10
            anchors.right: parent.right
            height: 22
            anchors.rightMargin: 10
            anchors.topMargin: 10
        }

        Text {
            id: mouseHoverValue
            anchors.top: parent.top
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 10
            anchors.right: mouseHoverTime.left
            anchors.rightMargin: 20
            height: 22
            anchors.topMargin: 10
        }
    }
}
