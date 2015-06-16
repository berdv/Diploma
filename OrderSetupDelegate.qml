import QtQuick 2.0
import "Variables.js" as Vars

import DB 1.0

Rectangle {

    id: container

    property real com_h: 100
    signal curStepCnahged;
    signal move();

    width: ListView.view.width
    height: ldr.item.implicitHeight

    color: "#efefef"//Vars.bgcolor

    border.width: 1
    border.color: "#50d5d5d5"

    Loader{
        id: ldr
        focus: true //was in comment
        anchors.fill: parent
        visible: true
    }

    function moveposition(){
        com_h = ldr.item.com_h;
        move()
    }


    function nextStep(){ curStepCnahged(); }

    Component.onCompleted: {

        ldr.source = "Order" + type + ".qml";
        ldr.item.label = label;
        if (type == "Control")
            ldr.item.mouseClicked.connect(nextStep);
        if (type == "ComboBox")
            ldr.item.list = cblist
        if(type == "CheckBoxE"){
            ldr.item.def = def;
            ldr.item.move.connect(moveposition);
        }
    }

}
