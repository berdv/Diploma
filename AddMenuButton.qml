import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
    id: root
    property string name: "Кнопка"
    property string pic
    property real position: 0

    signal buttonClicked;

    color: "transparent"
    //border.color: "blue"
    width: (parent.height > parent.width) ? parent.width: parent.width/2;
    height: (parent.height > parent.width) ? parent.height/2: parent.height;

    anchors{
        //connected to screen position
        left: parent.left
        leftMargin: (parent.height > parent.width) ? 0: width * position
        top: parent.top
        topMargin: (parent.height > parent.width) ? position*height : 0;
    }


    Rectangle{
        id: btn
        height: (parent.width > parent.height) ? parent.height/1.4 : parent.width/1.4
        width: height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: parent.height/15
        border.width: 2
        radius: 20//height/4

        gradient: Gradient {
            GradientStop { position: 0 ; color: ma.pressed ? "#ccc" : "#efefef"
                Behavior on color { ColorAnimation{ duration: 150 } }
            }
            GradientStop { position: 1 ; color: ma.pressed ? "#efefef" : "#ccc"
                Behavior on color { ColorAnimation{ duration: 150 } }
            }
        }

        MouseArea{
            id: ma
            anchors.fill: parent
            onClicked: buttonClicked()

            Image {
                id: img
                source: pic
                anchors.centerIn: parent
                anchors.fill: parent
            }

        }
    }

    Rectangle{
        border.width: 0
        color: "transparent"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: btn.top
        Text{
            text: name
            elide: Text.ElideMiddle
            fontSizeMode: Text.Fit
            wrapMode: Text.WordWrap
            minimumPixelSize: parent.height*0.1
            font.pixelSize: parent.height/2
            font.family: "Helvetica"
            anchors.centerIn: parent
        }
    }
}

