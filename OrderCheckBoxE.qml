import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import DB 1.0

Item{
    id: container
    anchors.fill: parent
    property bool value: false
    property real com_h: 191 //comment area height for moving
    property string label
    property real def: 1.0
    property bool typo_f: false
    width: parent.width
    signal move();

    implicitHeight: lbl.height + 20 + ext.height

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
            id: switcher
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
                ext.height = checked ? ext_lbl.height + ext_fld.height + com_lbl.height + com_area.height + 20: 0
                com_h = 191 + lbl.height + fld.height - 10;
                if(!check_item.isNum(elementsModel.get(index).ext))
                    typo_f = true;
            }

            onCheckedChanged: {
                container.value = checked;
                elementsModel.setProperty(index, "value", ((checked) ? "true" : "false"));
                ext.height = checked ? ext_lbl.height + ext_fld.height + com_lbl.height + com_area.height + 20: 0
                //com_h = com_area.height + 20
                if(!checked && typo_f){
                    ti.text = def;
                }
            }
        }
    }


    Rectangle{ //extra field with input
        id: ext
        color: "#304fb9ff"//c0c0c0"
        radius: 10



        Behavior on height { NumberAnimation { duration: 100 } }

        anchors.bottom: container.bottom
        anchors.horizontalCenter: container.horizontalCenter
        visible: switcher.checked

        width: container.width - 20
        height: 0 //ext_lbl.height + ext_fld.height


        Rectangle{
            id: ext_lbl
            color: "transparent"

            width: ext.width - 20
            height: ext_itemLabel.height + 20
            anchors.horizontalCenter: ext.horizontalCenter
            anchors.top: ext.top
            anchors.topMargin: 5

            Text {
                id: ext_itemLabel
                width: parent.width
                horizontalAlignment: Qt.AlignHCenter
                text: "Значение коэффициента"
                font.pixelSize: 35
                wrapMode: Text.WordWrap
            }
        }

        Rectangle{
            id: ext_fld
            anchors.top: ext_lbl.bottom
            width: ext.width
            height: ti_area.height + 10
            color: "transparent"

            //~~~~~~~~~~~~~~~~~~~~~~~Ratio input~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            Rectangle{
                id: ti_area
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: ext.width*0.5
                height: ti.font.pixelSize + 10

                Rectangle {anchors.bottom: parent.bottom; color: "#777"; width: parent.width; height: 3}

                TextInput{
                    id: ti
                    anchors.fill: parent
                    font.pixelSize: 37
                    horizontalAlignment: Qt.AlignHCenter
                    activeFocusOnPress: true
                    selectByMouse: activeFocus ? true : false
                    validator: RegExpValidator { regExp: /^\d{1,2}(\.\d{0,2}){0,1}$/ }
                    maximumLength: 5
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
                        if(!check_item.isNum(elementsModel.get(index).ext))
                            typo_f = true;
                        text = elementsModel.get(index).ext;
                    }

                    Check{id: check_item}

                    onTextChanged: {
                        value = ti.text
                        elementsModel.setProperty(index, "ext", text);

                        if(!check_item.isNum(text)){
                            ti_area.color = "#30ff4242";
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

            //~~~~~~~~~~~~~~~~~~~~~~~Comment input~~~~~~~~~~~~~~~~~~~~~~~~~~

            Rectangle{
                id: com_lbl
                color: "transparent"

                width: ext.width - 20
                height: com_itemLabel.height + 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: ti_area.bottom
                anchors.topMargin: 10

                Text {
                    id: com_itemLabel
                    width: parent.width
                    horizontalAlignment: Qt.AlignHCenter
                    text: "Комментарий"
                    font.pixelSize: 35
                    wrapMode: Text.WordWrap
                }
            }

            Rectangle{
                id: com_area
                color: "transparent"
                radius: 16
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: com_lbl.bottom
                //anchors.topMargin: 10
                width: ext.width*0.96
                height: com_ti.contentHeight + 10//com_ti.height + 10//com_ti.font.pixelSize + 10
                border.width: 2
                border.color: "#777"

                TextInput{
                    id: com_ti
                    anchors.fill: parent
                    font.pixelSize: 33
                    horizontalAlignment: Qt.AlignHCenter
                    activeFocusOnPress: true
                    selectByMouse: activeFocus ? true : false
                    maximumLength: 200
                    wrapMode: TextInput.WordWrap

                    Keys.onReturnPressed: {
                        Qt.inputMethod.hide();
                        focus = false;
                    }
                    Keys.onBackPressed: {
                        Qt.inputMethod.hide();
                        focus = false
                    }
                    Component.onCompleted: {
                        text = elementsModel.get(index).comment;
                        //com_h = com_area.height + 20;
                    }

                    Keys.onPressed: {
                        ext.height = ext_lbl.height + ext_fld.height + com_lbl.height + com_area.height + 20
                        //com_h = com_area.height + 20
                    }

                    onTextChanged: {
                        elementsModel.setProperty(index, "comment", text);
                        ext.height = switcher.checked ? ext_lbl.height + ext_fld.height + com_lbl.height + com_area.height + 20: 0
                        //com_h = com_area.height + 20;
                    }

                    //onContentHeightChanged: move();

                    onActiveFocusChanged: {
                        if(activeFocus == true){
                            move();
                        }
                    }
                }
            }
            //~~~~~~~~
        }
    }
}

