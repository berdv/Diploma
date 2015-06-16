import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Item{
    id: container
    anchors.fill: parent
    property bool value: false
    property string label
    width: parent.width
    implicitHeight: lbl.height + 20

    Rectangle{
        id: lbl
        color: "transparent"

        width: container.width - fld.width - 4
        height: itemLabel.height + 20
        anchors.top: parent.top
        anchors.topMargin: 10

        Text {
            id: itemLabel
            anchors{
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            width: parent.width - 30
            text: label
            font.pixelSize: 40
            wrapMode: Text.WordWrap
        }
    }

    Rectangle{
        id: fld
        color: "transparent"
        anchors.verticalCenter: lbl.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 16
        height: 70
        width: height*1.7

        Switch{
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            style: SwitchStyle{
                groove: Rectangle {
                    implicitWidth: fld.height*1.7
                    implicitHeight: fld.height
                    radius: fld.height/2
                    color: control.checked ? "#4fb9ff" : "#959595"
                    border.width: 1
                    border.color: "#999"

                    Image{
                        anchors{
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: 5
                        }

                        height: parent.height - 16
                        width: height
                        source: "images/check.png"
                        visible: control.checked ? true : false

                        Behavior on visible {NumberAnimation { duration: 200}}
                    }

                    Image{
                        anchors{
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            rightMargin: 5
                        }

                        height: parent.height - 16
                        width: height
                        source: "images/uncheck.png"
                        visible: control.checked ? false : true
                        Behavior on visible {NumberAnimation { duration: 150}}
                    }

                    Behavior on color {ColorAnimation{duration: 50}}
                }
                handle: Rectangle{
                    implicitHeight: fld.height
                    implicitWidth: implicitHeight
                    color: "#d5d5d5"//"#ccc"
                    border.width: 2
                    border.color: control.checked ? "#20a0e0" : "#777"
                    radius: fld.height/2

                    Behavior on border.color {ColorAnimation{duration: 150}}
                }
            }

            Component.onCompleted: {
                checked = (elementsModel.get(index).value == "true")
            }

            onCheckedChanged: {
                container.value = checked;
                elementsModel.setProperty(index, "value", ((checked) ? "true" : "false"));
            }
        }
    }
}

