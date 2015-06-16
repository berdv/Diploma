import QtQuick 2.3
import QtQml 2.2
import "Variables.js" as Vars

Rectangle{
    property double max: 1.0
    id: container
    radius: 20
    color: "transparent"
    width: stat_v.width
    height: stat_v.height

    Rectangle{ //workarea
        id: graph_area
        width: parent.width - 20
        height: parent.height- 20
        anchors.centerIn: parent
        color: "transparent"

        Rectangle{
            width: parent.width
            height: 60
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            color : "transparent"

            Text{
                anchors.fill: parent
                horizontalAlignment: Qt.AlignHCenter
                id: lbl
                text: label
                font.pixelSize: 50
            }
        }

        Rectangle{
            id: graph
            width: parent.width
            height: parent.height - lbl.height - 5
            anchors.bottom: parent.bottom


            color: "transparent"
            Column{
                width: parent.width
                height: parent.height
                Repeater{
                    model: 4

                    Rectangle{
                        id: column_a
                        width: parent.width
                        height:  parent.height/4
                        color: "transparent"

                        Text{
                            property real m: Math.pow(10, 2);
                            anchors.fill: parent
                            verticalAlignment: Qt.AlignVCenter
                            horizontalAlignment: Qt.AlignHCenter
                            text: "<b>" + tab_lbl.get(index).val + "</b><br>" +
                                  Math.round(value.get(index).val*m)/m + ((index < 3) ? "р" : "")
                            font.pixelSize: 40
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }

        }

    }
}
