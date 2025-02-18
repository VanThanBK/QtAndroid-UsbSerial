import QtQuick
import QtQuick.Controls


Item {
    id: comboBoxWithCheckBox

    implicitWidth: 100
    implicitHeight: 30

    signal selectedChanged(string model_name, bool ischecked)

    property color colorDefault: "transparent"
    property color colorBorder: "#aaaaaa"

    function clearList()
    {
        modelPort.clear()
    }

    function addElement(name, ischecked)
    {
        modelPort.append({ text: name, checked: ischecked})
    }

    function getListModel()
    {
        return comboBox.model
    }

    ComboBox {
        id: comboBox
        anchors.fill: parent

        QtObject{
            id: internal
            property var getDisplayText: {
                var number_of_line_show = 0;
                for (var index = 0; index < comboBox.model.count; index++)
                {
                    if (comboBox.model.get(index).checked === true)
                    {
                        number_of_line_show++;
                    }
                }
                return "Show " + number_of_line_show.toString() + " line"
            }
        }

        model: ListModel {
                id: modelPort
                ListElement { text: "desire_dis"
                              checked: true }
                ListElement { text: "desire_vel"
                              checked: true }
            }

        delegate: CheckDelegate {
            text: model.text
            width: comboBox.width
            height: 30
            // highlighted: comboBox.highlightedIndex == index
            checked: model.checked
            onCheckedChanged: {
                model.checked = checked
                selectedChanged(model.text, model.checked)
            }
        }

        background: Rectangle {
            radius: 6
            border.width: 1
            color: comboBoxWithCheckBox.colorDefault
            border.color: comboBoxWithCheckBox.colorBorder
            Image {
                source: "qrc:/images/icons8-sort-down-24.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
            }
        }

        displayText: internal.getDisplayText
    }
}
