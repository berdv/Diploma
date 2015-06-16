import QtQuick 2.0

Item{
    id: container
    property int type
    width: parent.width
    height: 100

    Rectangle{
        width: parent.width
        height: 100
        Loader{
            id: ldr
            anchors.fill: parent
            source: (type == 0) ? "DrillItem.qml" : "SawItem.qml"; // (type == 1) ? "SawItem.qml" : ((type == 0) ? "DrillItem.qml" : "")
        }
    }
}

