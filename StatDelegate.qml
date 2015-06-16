import QtQuick 2.3
import QtQml 2.2

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

        Text{
            id: lbl
            width: parent.width
            height: 60
            anchors.top: parent.top
            horizontalAlignment: Qt.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            text: label
            font.pixelSize: 50
        }

        Rectangle{
            id: axis
            height: graph.height
            width: 2
            anchors.top: graph.top
            anchors.left: graph.right
            border.color: "black"
            visible: tabs ? true : false;
        }

        Rectangle{ //graph
            id: graph
            width: parent.width  - 24
            height: parent.height - lbl.height - 5
            color: "transparent"

            anchors{
                bottom: parent.bottom
                //horizontalCenter: parent.horizontalCenter
                left: parent.left
                leftMargin: 5
            }

            visible: tabs ? true : false

            Row{
                width: parent.width
                height: parent.height
                Repeater{
                    model: tabs

                    Rectangle{
                        id: column_b
                        width: graph.width/tabs
                        height:  graph.height//graph.height
                        color: "transparent"
                        Rectangle{
                            id: column
                            anchors.bottom: parent.bottom
                            width: parent.width - 4
                            height:  1//graph.height
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: index ? "#50b9fd" : "#fdba4f"

                            Behavior on height { NumberAnimation { duration: 400}}
//                            Behavior on color  { ColorAnimation  { duration: 400}}
                            Component.onCompleted: {
                                var i;
                                max = value.get(0).val;
                                for(i=1; i<value.count; i++)
                                    if(value.get(i).val > max)
                                        max = value.get(i).val

                                height = 1 + (graph.height - 1) * value.get(index).val/max;
//                                color = Qt.rgba(1 - value.get(index).val/max,
//                                                0.26 + 0.54*value.get(index).val/max,
//                                                0.26 - 0.06*value.get(index).val/max, 0.9);
                            }

                            Text{
                                property real m: Math.pow(10,2);
                                width: column.width
                                anchors.bottom: column.bottom
                                anchors.bottomMargin: 10
                                horizontalAlignment: Qt.AlignHCenter
                                text: "<b>" + Math.round(value.get(index).val*m)/m  + "</b><br>" + tab_lbl.get(index).val
                                font.pixelSize: 20
                            }

                            Rectangle{
                                color: "black"
                                border.width: 2
                                height: 2
                                width: 10
                                x: (column_b.width)* (tabs - index)
                                anchors.top: column.top
                                Rectangle{
                                    height: 8
                                    width: 8
                                    color: column.color
                                    border.width: 1
                                    border.color: "#777"
                                    anchors.left: parent.right
                                    anchors.leftMargin: -4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
