import QtQuick 2.3
import QtQuick.Controls 1.3
import "Variables.js" as Vars

Item{
    id: container
    property string label: "Далее"
    signal mouseClicked;
    implicitHeight: fld.height
    width: parent.width

    Rectangle{
        id: fld
        width: container.width
        height: 100
        color: "transparent"

        Rectangle{
            id: btn
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height - 10
            width: parent.width/2.1

            border.color: Vars.bdcolor

            radius: 20//height/4

            gradient: Gradient{
                GradientStop { position: 0 ; color: ma.pressed ? "#ccc" : "#fff" }
                GradientStop { position: 1 ; color: ma.pressed ? "#fff" : "#ccc"}
            }

            Behavior on  color{ ColorAnimation{duration: 50}}

            MouseArea{
                id: ma
                anchors.fill: parent
                onClicked: { mouseClicked(); }
            }

            Rectangle{
                width: parent.width - img.width
                height: parent.height
                anchors{
                    horizontalCenter: btn.horizontalCenter
                    verticalCenter: btn.verticalCenter
                    horizontalCenterOffset: -img.width/2 + 15
                }
                color: "transparent"
                Text {
                    id: lbl
                    text: label
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: btn.height/3.2
                    minimumPixelSize: 20
                    fontSizeMode: Text.Fit

                }
            }

            Image{
                id: img
                anchors.right: btn.right
                anchors.rightMargin: -10
                anchors.verticalCenter: btn.verticalCenter
                height: btn.height - 10
                width: height
                source: "images/arrownext.png"
            }

        }
    }
}

