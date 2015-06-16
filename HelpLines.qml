import QtQuick 2.0

Rectangle{
    color: "transparent"
    border.width: 0
    anchors.centerIn: parent;
    anchors.fill: parent;

    Rectangle{ //Vertical line
        anchors.horizontalCenter: parent.horizontalCenter;
        width: 1; height: parent.height; color: "black"; border.width: 0
    }

    Rectangle{
        width: parent.width; height: 1;
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height/4;
        color: "red"; border.width: 0
    }

    Rectangle{
        width: parent.width; height: 1;
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height*3/4;
        color: "red"; border.width: 0
    }

    Rectangle{ //Horizontal line
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width; height: 1; color: "black"; border.width: 0
    }

    Rectangle{
        width: 1; height: parent.height;
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.width/4;
        color: "red"; border.width: 0
    }

    Rectangle{
        width: 1; height: parent.height;
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.width*3/4;
        color: "red"; border.width: 0
    }
}

