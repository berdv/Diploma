import QtQuick 2.3
import QtQuick.Controls 1.2
import "Variables.js" as Vars

Rectangle{
    signal approved(int day, int month, int year);
    signal canceled;

    property int type: 0

    id: date_selector
    anchors.fill: parent
    color: "#80303030"
    z: 2

    MouseArea{
        anchors.fill: parent
        onClicked: deny()
    }

    Keys.onReleased: {
        if (event.key == Qt.Key_Back) {
            event.accepted = false
            canceled();
        }
    }

    function confirm() { approved(d_pick.day, d_pick.month, d_pick.year)}
    function deny() { canceled()}

    Component.onCompleted: {type = Vars.sel_type}

    Rectangle{
        id: brd
        anchors.centerIn: parent
        width: parent.width*0.85
        height: parent.height*0.85
        radius: 20//parent.width*0.05
        border.color: Vars.bdcolor
        color: "#efefef"//Vars.bgcolor

        Rectangle{
            id: work_area
            anchors.centerIn: parent
            width: parent.width - parent.radius - 10
            height: parent.height - parent.radius - 10
            color: "#efefef"//Vars.bgcolor


            DatePick{
                id:d_pick

                Component.onCompleted: {
                    if(type == 0){ //since selector
                        day = Vars.curd
                        month = Vars.curm
                        year = Vars.cury
                    }
                    else{ //until selector
                        minday = Vars.mind;
                        minmonth = Vars.minm;
                        minyear = Vars.miny;
                    }

                }

                height: work_area.height - 100
                width: work_area.width
                anchors.fill: work_area
            }


        }
    }
}
