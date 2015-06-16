import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.3
import "Variables.js" as Vars

Rectangle{
    property string bcolor: "#ff4242"
    property real position: 0
    property bool activated: false

    signal buttonClicked;

    id: root

    color: "transparent"
    width: parent.width/parent.navamount
    height: parent.height - 2
    anchors.left: parent.left
    anchors.leftMargin: width*position
    anchors.verticalCenter: parent.verticalCenter

    MouseArea{
        hoverEnabled: true
        anchors.fill: parent
        anchors.centerIn: parent

        onPressed:  {shade.visible = true; btn.scale = 0.8; btn.radius = 20./*btn.height/4*/; btn.rotation = 45}
        onReleased: {shade.visible = false; btn.scale = 1;btn.radius = btn.height/2; btn.rotation = -45}

        onClicked: {
            if(activated){
                buttonClicked();
            }
        }
    }

    Rectangle{
        id: btn
        color: (activated) ? "#00cc33" : "#ff4242"
        border.width: 2
        border.color: Vars.bdcolor

        radius: height/2
        Behavior on radius { NumberAnimation{duration: 50}}

        height: (root.height > root.width) ? root.width * 0.85 : root.height * 0.85
        width: height
        Behavior on scale {
            SequentialAnimation {
                NumberAnimation{duration: 50}
                RotationAnimation{duration: 60}
            }
        }
        //Behavior on rotation { RotationAnimation{duration: 60}}

        anchors.centerIn: parent


        Rectangle{
            id: shade
            radius: parent.radius
            anchors.fill: parent
            color: "#40CCCCCC"
            visible: false
        }

//        MouseArea{
//            hoverEnabled: true
//            anchors.fill: parent
//            anchors.centerIn: parent

//            onPressed:  {shade.visible = true; btn.scale = 0.8; btn.radius = btn.height/4; btn.rotation = 45}
//            onReleased: {shade.visible = false; btn.scale = 1;btn.radius = btn.height/2; btn.rotation = -45}

//            onClicked: {
//                if(activated){
//                    buttonClicked();
//                }
//            }
//        }
    }
}

