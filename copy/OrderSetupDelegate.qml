
import QtQuick 2.0
import "Variables.js" as Vars

Rectangle {

    id: container

    signal curStepCnahged;

    width: ListView.view.width
    height: item.implicitHeight

    color: "#efefef"//Vars.bgcolor

    border.width: .5
    border.color: "#50d5d5d5"

    Item {
        id: item
        implicitHeight: (type != "checkbox") ? lbl.implicitHeight + fld.implicitHeight : lbl.implicitHeight
        height: implicitHeight
        width: parent.width

        Rectangle{ //label of item
            id: lbl
            color: "transparent"

            width: (type != "checkbox") ? container.width : container.width - fld.width;
            anchors.left: item.left

            implicitHeight: (type != "control" && type != "splitter")  ? (type != "checkbox" ? itemLabel.height + 20: itemLabel.height + 40) : 0;
            Text {
                id: itemLabel
                anchors{
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }

                width: parent.width - 30
                text: (type != "control" && type != "splitter" ) ? label : "" //variable from addItem function
                color: "black"
                font.pixelSize: 40
                wrapMode: Text.WordWrap
                styleColor: "white"
            }
        }
        Rectangle{ //item activity
            id: fld
            color: "transparent"

            anchors{
                top: (type != "checkbox") ? lbl.bottom : item.top;
                right: item.right
            }

            width: (type != "checkbox") ? item.width : 140 + 15
            implicitHeight: (type != "checkbox") ? (type != "splitter" ? 100 : 50) : lbl.implicitHeight;

            Loader{
                id: ldr
                focus: true //was in comment
                anchors.fill: parent
                visible: true
            }

            function nextStep(){ curStepCnahged(); }

            Component.onCompleted: {
                switch(type){
                    case "textinput": ldr.source = "OrderTextInput.qml"; break;
                    case "numinput": ldr.source = "OrderNumInput.qml"; break;
                    case "checkbox": ldr.source = "OrderCheckBox.qml"; break;
                    case "combobox": {
                        ldr.source = "OrderComboBox.qml";
                        ldr.item.list = cblist;
                        break;
                    }
                    case "control": {
                        ldr.source = "OrderControl.qml";
                        ldr.item.mouseClicked.connect(nextStep);
                        ldr.item.label = label;
                        break;
                    }
                    case "splitter": {
                        ldr.source = "OrderSplitter.qml";
                        ldr.item.label = label;
                        break;
                    }
                    default: break;
                }
            }

        }
    }
}
