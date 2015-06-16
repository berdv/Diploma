import QtQuick 2.0
import "Variables.js" as Vars

Rectangle {
    id: rootRect

    property double itemHeight: parent.height/3//8*Vars.mm
    property alias model: listView.model

    signal indexChanged(int value)

    function setValue(value) {
        //listView.
        listView.positionViewAtIndex(value, ListView.Center);
        listView.currentIndex = value
        var centralIndex = listView.indexAt(listView.contentX+1,listView.contentY+itemHeight+itemHeight/2)
        gotoIndex(centralIndex)
//        indexChanged(value)
    }
    color: "transparent"
    anchors.verticalCenter: parent.verticalCenter

    ListView {
        id: listView
        clip: true
        anchors.fill: parent
        contentHeight: itemHeight*3

        delegate: Item {
            property var isCurrent: ListView.isCurrentItem
            id: item

            height: itemHeight
            width:  listView.width

            Rectangle {
                anchors.fill: parent
                color: "transparent"

                Text {
                    text: model.text
                    font.pixelSize: itemHeight/3.4
                    width: parent.width
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    //fontSizeMode: Text.Fit
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        rootRect.gotoIndex(model.index)
                    }
                }
            }
        }
        onMovementEnded: {
            var centralIndex = listView.indexAt(listView.contentX+1,listView.contentY+itemHeight+itemHeight/2)
            gotoIndex(centralIndex)
            indexChanged(currentIndex)
        }
    }

    function gotoIndex(inIndex) {
        anim.running = false;
        var begPos = listView.contentY;
        var destPos;

        listView.positionViewAtIndex(inIndex, ListView.Center);
        destPos = listView.contentY;

        anim.from = begPos;
        anim.to = destPos;
        anim.running = true;

        listView.currentIndex = inIndex
    }

    NumberAnimation {
        id: anim;

        target: listView;
        property: "contentY";
        easing {
            type: Easing.OutInExpo;
            overshoot: 50
        }
    }

    function next() {
        gotoIndex(listView.currentIndex+1)
    }

    function prev() {
        gotoIndex(listView.currentIndex-1)
    }
}
