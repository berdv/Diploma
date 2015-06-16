import QtQuick 2.0
import "Variables.js" as Vars

Rectangle {
    id: container
    property alias model: pickerList.model
    property real wdth: 200

    signal indexSelected(int value)

    function setValue(value) {
        pickerList.setValue(value)
    }

    width: wdth*0.96
    height: parent.height - 10
    color: "transparent"
    anchors.verticalCenter: parent.verticalCenter

    ACPickerList {
        id: pickerList

        width: parent.width
        height: parent.height

        onIndexChanged: {
            indexSelected(value)
        }
    }

    Image {
        id: upShadow

        height: container.height/3
        width: container.width - 6

        source: "images/topshadow.png"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        id: downShadow

        height: container.height/3
        width: container.width
        source: "images/bottomshadow.png"

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
    }

    /*
    Rectangle {
        id: topSelector

        width: container.width
        height: container.height*0.01
        color: "#4fb9ff"

        anchors {
            top: parent.top
            topMargin: pickerList.itemHeight
        }
    } */

//    Rectangle {
//        id: bottomSelector

//        width: parent.width
//        height: pickerList.itemHeight//container.height*0.01
//        color: "#304fb9ff"

//        anchors {
//            top: parent.top
//            topMargin: pickerList.itemHeight
//        }
//    }
}
