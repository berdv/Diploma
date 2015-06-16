import QtQuick 2.0
import QtQuick.Controls.Styles 1.2
import "Variables.js" as Vars
import DB 1.0

Item{
    id: container

    signal typop;
    signal typon;
    implicitHeight: lbl.height + fld.height
    property string value: "0"
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
            width: container.width*0.5
            height: ti.font.pixelSize + 10
            color: "transparent"

            Rectangle {anchors.bottom: parent.bottom; color: "#777"; width: parent.width; height: 3}

            TextInput{
                id: ti
                anchors.fill: parent
                font.pixelSize: 37
                horizontalAlignment: Qt.AlignHCenter
                activeFocusOnPress: true
                selectByMouse: activeFocus ? true : false

                RegExpValidator {id: rv; regExp: /^\d{1,2}(\.\d{0,2}){0,1}$/ }
                RegExpValidator {id: dv; regExp: /^\d{1,5}(\.\d{0,3}){0,1}$/ }
                RegExpValidator {id: iv; regExp: /^\d{1,6}$/ }

                validator: {
                    switch(numtype){
                    case "ratio": rv; break;
                    case "int": iv; break
                    default: dv; break;
                    }
                }
                //maximumLength: 6
                inputMethodHints: Qt.ImhFormattedNumbersOnly

                Keys.onReturnPressed:
                {
                    Qt.inputMethod.hide();
                    focus = false
                }
                Keys.onBackPressed: {
                    focus = false
                }
                Component.onCompleted: {
                    if(!check_item.isNum(elementsModel.get(index).value))
                        typo_f = true;
                    text = elementsModel.get(index).value;
                }

                Check{id: check_item}

                onTextChanged: {
                    value = ti.text
                    //index is outer element, but we have acces to it, cos it's from his parent
                    elementsModel.setProperty(index, "value", text);
                    if(!check_item.isNum(text)){
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
