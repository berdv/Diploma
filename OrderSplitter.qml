import QtQuick 2.0
import "Variables.js" as Vars

Item {
    id: container
    property string label: ""
    width: parent.width
    implicitHeight: fld.height

    Rectangle{
        id: fld
        color: "#e3e3e3"
        width: parent.width
        height: fld_txt.height + 10
        anchors.verticalCenter: container.verticalCenter
        Rectangle{
            anchors.centerIn: fld
            width: container.width
            height: fld_txt.height + 4
            color: "transparent"
            Text{
                id: fld_txt
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment:  Qt.AlignVCenter
                width: container.width
                font.pixelSize: 35
                wrapMode: Text.WordWrap
                text: label
            }
        }
    }
}

