import QtQuick 2.3
import "Variables.js" as Vars

Item {
    id: container

    property variant scrollArea
    property int orientation: Qt.Vertical

    opacity: 0

    function position()
    {
        var ny = 0;
        if (container.orientation == Qt.Vertical)
            ny = scrollArea.visibleArea.yPosition * container.height;
        else
            ny = scrollArea.visibleArea.xPosition * container.width;

        if (ny > 2)
            return ny;
        else
            return 2;
    }

    function size()
    {
        var nh;
        var ny;

        if (container.orientation == Qt.Vertical)
            nh = scrollArea.visibleArea.heightRatio * container.height;
        else
            nh = scrollArea.visibleArea.widthRatio * container.width;

        if (container.orientation == Qt.Vertical)
            ny = scrollArea.visibleArea.yPosition * container.height;
        else
            ny = scrollArea.visibleArea.xPosition * container.width;

        if (ny > 3) {
            var t;
            if (container.orientation == Qt.Vertical)
                t = Math.ceil(container.height - 3 - ny);
            else
                t = Math.ceil(container.width - 3 - ny);
            if (nh > t)
                return t;
            else
                return nh;
        } else
            return nh + ny;
    }

    Rectangle { //scrollbar track
            id: track
            height: (orientation == Qt.Vertical) ? parent.height: 4
            width: (orientation == Qt.Vertical) ? 4 : parent.width
            anchors.right: parent.right
            anchors.rightMargin: (orientation == Qt.Vertical) ? 6 : 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: (orientation == Qt.Vertical) ? 0 : 6

            color: "#777"
            opacity: 0.3
        }

    Rectangle{ //scrollbar handle
        id: handle
        //radius: container.orientation == Qt.Vertical ? width/2 :  height/2
        color: "#222"
        opacity: 0.5
        x: container.orientation == Qt.Vertical ? parent.width - 11: position()
        y: container.orientation == Qt.Vertical ? position() : parent.height - 11
        width: container.orientation == Qt.Vertical ? 6 : size()
        height: container.orientation == Qt.Vertical ? size() : 6
    }

    states: State {
        name: "visible"
        when: container.orientation == Qt.Vertical ?
                  scrollArea.movingVertically :
                  scrollArea.movingHorizontally
        PropertyChanges { target: container; opacity: 1.0 }
    }

    transitions: Transition {
        from: "visible"; to: ""
        NumberAnimation { properties: "opacity"; duration: 600 }
    }
}

