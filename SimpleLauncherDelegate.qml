
import QtQuick 2.0

Rectangle {
    id: container
    property Item menuItem
    width: (app.height > app.width) ? ListView.view.width/3 : ListView.view.width
    height: (app.height > app.width) ? ListView.view.height : ListView.view.height/3//button.implicitHeight + 22

    gradient: Gradient {
        GradientStop { position: 0 ; color: mouseArea.pressed ? "#ddd" : "#eee"
            Behavior on color {
                ColorAnimation{
                    duration: 250
                }
            }
        }
        GradientStop { position: 0.5 ; color: mouseArea.pressed ? "#fff" : "#ccc"
            Behavior on color {
                ColorAnimation{
                    duration: 250
                }
            }
        }
        GradientStop { position: 1 ; color: mouseArea.pressed ? "#ddd" : "#eee"
            Behavior on color {
                ColorAnimation{
                    duration: 250
                }
            }
        }
    }

    Item {
        id: button
        anchors.fill: parent

        implicitHeight: image.height
        implicitWidth: buttonLabel.width
        height: implicitHeight
        width: buttonLabel.width

        Image {
            id: image
            source: pic
            height: (container.height > container.width) ? container.width*0.8: container.height*0.8
            width: height
            anchors{
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
                //horizontalCenterOffset: (app.height > app.width) ?  0: buttonLabel.font.pointSize/2
                verticalCenterOffset: -buttonLabel.font.pointSize/2 //moves to top for text
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: (url == "") ? Qt.quit() :menuItem.nextPage = url
            hoverEnabled: true
        }
        Text {
            id: buttonLabel
            anchors{
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: image.height/2
                //verticalCenterOffset: (app.height > app.width) ? image.height/2 : 0
                //horizontalCenterOffset: (app.height > app.width) ? 0 : -image.width/2
            }

            text: name
            color: "black"
            font.pixelSize: 18
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            styleColor: "white"
            style: Text.Raised
            //rotation: (app.height > app.width) ? 0 : 90

        }
    }

    Rectangle {
        height: 1
        color: "#ccc"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
