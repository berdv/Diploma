import QtQuick 2.0
import "Variables.js" as Vars

Rectangle {
    property int type
    id: container
    anchors.fill: parent
    color: "#80707070"

    MouseArea{
        anchors.fill: parent
        onClicked: billLoader.source = ""
    }

    Rectangle{
        color: "transparent"
        width: parent.width - 30
        height: parent.height*0.85
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter


        Rectangle{
            width: parent.width
            height: container.height*0.7
            color: "#efefef"
            border.width: 2
            border.color: "#333"
            anchors.horizontalCenter: parent.horizontalCenter

            ListView{
                id: bill_v
                width: parent.width - 4
                height: parent.height - 4
                anchors.centerIn: parent

                boundsBehavior: Flickable.StopAtBounds

                model: certainModel

                delegate:  Loader{
                    id: viewLoader
                    width: parent.width
                    source: (type == 1) ? "ViewSawDelegate.qml" : ((type == 0) ? "ViewDrillDelegate.qml" : "")
                }

                displaced: Transition {NumberAnimation { properties: "y"; duration: 130 } }

                ScrollBar{ anchors.fill: parent; scrollArea:  bill_v}
            }
        }

        Rectangle{
            width: parent.width
            height: container.height*0.15
            anchors.bottom: parent.bottom
            color: "transparent"
            Rectangle{
                anchors.centerIn: parent
                width: parent.width
                height: 100
                radius: 20
                border.color: Vars.bdcolor
                border.width: 2

                gradient: Gradient{
                    GradientStop { position: 0 ; color: ma.pressed ? "#c8c8c8" : "#efefef"
                        Behavior on color { ColorAnimation{ duration: 250 } }
                    }
                    GradientStop { position: 1 ; color: ma.pressed ? "#efefef" : "#c8c8c8"
                        Behavior on color { ColorAnimation{ duration: 250 } } }
                }

                MouseArea{
                    id: ma
                    anchors.fill: parent

                    onClicked: billLoader.source = ""
                }

                Text{
                    anchors.fill: parent
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignHCenter
                    font.pixelSize: 40
                    text: "Назад"
                }

            }
        }
    }
}

