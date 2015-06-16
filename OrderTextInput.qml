import QtQuick 2.0
import QtQuick.Controls.Styles 1.2
import "Variables.js" as Vars
import DB 1.0

Item{
    id: container
    implicitHeight: lbl.height + fld.height
    property string value: "."
    property string label
    property bool typo_f: false

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
        }
    }

    Rectangle{
        id: fld
        anchors.top: lbl.bottom
        width: container.width
        height: ti_area.height + 10
        color: "transparent"

        Rectangle{
            id: ti_area
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: container.width - 30
            height: ti.font.pixelSize + 10
            color: "transparent"

            Rectangle {anchors.bottom: parent.bottom; color: "#777"; width: parent.width; height: 3}

            TextInput{
                id: ti
                anchors.fill: parent
                font.pixelSize: 37
                activeFocusOnPress: true
                selectByMouse: activeFocus ? true : false
                maximumLength: 255

                Keys.onReturnPressed:
                {
                    Qt.inputMethod.hide();
                    focus = false
                }
                Keys.onBackPressed: {
                    focus = false
                }
                Component.onCompleted: {
                    text = elementsModel.get(index).value;
                    if(texttype == "required"){
                        if(!check_item.isStr(text)){
                            if(text == ""){ text = " "; text = ""; }
                        }
                    }
                }

                Check{id: check_item}

                onTextChanged: {
                    value = ti.text
                    elementsModel.setProperty(index, "value", text);
                    if(texttype == "required"){
                        if(!check_item.isStr(text)){
                            ti_area.color = "#50ff4242";
                            if(!typo_f){
                                typo_f = true;
                                check = check + 1;
                            }
                        }
                        else{
                            ti_area.color = "transparent"
                            if(typo_f){
                                typo_f = false;
                                check = check - 1;
                            }
                        }
                    }
                }
            }
        }
    }
}
