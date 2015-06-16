import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

Item{
    id: container

    property var list
    property string label: ""
    property string value

    width: parent.width
    implicitHeight: lbl.height + fld.height


    Rectangle{
        id: lbl
        color: "transparent"

        width: container.width
        height: itemLabel.height + 20

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
            styleColor: "white"
        }
    }

    Rectangle{
        id: fld
        anchors.top: lbl.bottom
        width: container.width
        height:  100
        color: "transparent"

        ComboBox{
            id: cb
            model: list
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            editable: false
            width: parent.width - 32
            height: parent.height - 8
            style: cbstyle            

            Component.onCompleted: { //doesn't work correct
                /*var ind = index;
                console.log("index is " + ind);
                currentIndex = elementsModel.get(index).cb_ind;*/
            }

            onActivated: {
                /*
                elementsModel.setProperty(index, "value", currentText);
                elementsModel.setProperty(index, "cb_ind", currentIndex);*/
            }

            onCurrentIndexChanged: {
                if(currentText != ""){
                    elementsModel.setProperty(index, "value", currentText);
                    elementsModel.setProperty(index, "cb_ind", currentIndex);
                }
                else
                    elementsModel.setProperty(index, "value", currentText);

            }
        }

        Component{
            id: cbstyle
            ComboBoxStyle{
                label: Text{
                    verticalAlignment: Qt.AlignVCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    text: control.currentText
                    anchors.fill: parent
                    font.pixelSize: 30
                    font.family: "Helvetica"
                }
                background: Rectangle{
                    id: bckg
                    anchors.fill: parent
                    radius: 20//control.height/4
                    border.width: 1
                    border.color: "#777"

                    color: "#d5d5d5"

                    Image{
                        anchors.right: parent.right
                        anchors.rightMargin: 5
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height
                        width: height
                        source: control.pressed ? "images/cbarrowup.png" : "images/cbarrowdown.png"
                    }
                }
            }
        }
    }
}
