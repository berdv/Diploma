import QtQuick 2.0

Rectangle {
    id: root
    property string name: "Кнопка"
    property string pic
    property real position: 0

    signal buttonClicked;

    width: mainmenu.width/1.2;
    height: (mainmenu.height - 2*mainmenu.height/10)/4 - 20;
    anchors.horizontalCenter: mainmenu.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: position * (height + 20) + mainmenu.height/10
    border.width: 2
    radius: 20//height/4

    gradient: Gradient {
        GradientStop { position: 0 ; color: ma.pressed ? "#ccc"/*"lightgrey"*/ : "#efefef"
            Behavior on color { ColorAnimation{ duration: 250 } }
        }
        GradientStop { position: 1 ; color: ma.pressed ? "#efefef" : "#ccc"//"lightgrey"
            Behavior on color { ColorAnimation{ duration: 250 } }
        }
    }

    MouseArea{
        id: ma
        anchors.fill: parent
        onClicked: buttonClicked()

        Rectangle{
            id: img
            height: root.height;
            width: root.height;
            radius: 20//root.height/4
            border.width: 2
            color: "transparent"
            Image {
                source: pic
                anchors.centerIn: parent
                anchors.fill: parent
            }
        }

        Text{
            font.family: "Helvetica"
            font.pointSize: img.height * 0.25
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: img.width/2
            text:  name
        }
    }
}

