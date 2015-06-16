
import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import "Variables.js" as Vars

Rectangle {

    property Item menuItem

    id: container

    Rectangle{id: shadow; anchors.fill: parent; color: "black" ; visible: false}

    MessageDialog{
        id: mdialog
        standardButtons: StandardButton.Yes | StandardButton.No
        function show(warning) {
            mdialog.text = warning;
            mdialog.open();
        }

        onYes: {
            Vars.started_f = false;
            menuItem.prevPage = menuItem.nextPage;
            menuItem.nextPage = url
            Vars.cur_scr = 0
        }
    }

    MessageDialog{
        id: qdialog
        standardButtons: StandardButton.Yes | StandardButton.No
        function show() {
            if(Vars.started_f)
                qdialog.text = "Выйти на начальный экран?\nВсе несохраненные данные будут удалены";
            else{
                if(menuItem.nextPage == "")
                    qdialog.text = "Выйти из программы?";
                else
                    qdialog.text = "Выйти на начальный экран?";
            }

            qdialog.open()
        }
        onYes: {
            if(Vars.started_f) {
                Vars.started_f = false;
//                menuItem.prevPage = menuItem.nextPage;
                menuItem.nextPage = "";
            }
            else{
                if(menuItem.nextPage == "")
                    Qt.quit()
                else
                    menuItem.nextPage = "";
            }
        }
    }


    width: (app.height > app.width) ? ListView.view.width/4 : ListView.view.width
    height: (app.height > app.width) ? ListView.view.height : ListView.view.height/4//button.implicitHeight + 22

    border.width: 1
    border.color: Vars.bdcolor//"#20202020"

    gradient: Gradient {
        GradientStop { position: 0 ; color: mouseArea.pressed ? "#ccc" : "#ddd"
            Behavior on color { ColorAnimation{ duration: 150 } }
        }
        GradientStop { position: 0.5 ; color: mouseArea.pressed ? "#aaa" : "#ccc"
            Behavior on color { ColorAnimation{ duration: 150 } }
        }
        GradientStop { position: 1 ; color: mouseArea.pressed ? "#ccc" : "#ddd"
            Behavior on color { ColorAnimation{ duration: 150 } }
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
                verticalCenterOffset: -buttonLabel.font.pointSize/2 - 5 //moves to top for text
            }
        }

        MouseArea {

            id: mouseArea
            anchors.fill: parent

            onClicked: {
                if(Vars.started_f){
                    switch(url){
                    case "": qdialog.show(/*"Выйти в главное меню?"*/); break;
                    case "qrc:/AddMenu.qml": break;
                    default: mdialog.show("Текущая задача не завершена и все введенные данные будут удалены\nПродолжить?");
                    }
                }
                else{
                    if(url == "")
                        qdialog.show()
                    else{
                        var str = data_b.getMinimumDate();
                        Vars.curd = str.slice(8, 10);
                        Vars.curm = str.slice(5, 7);
                        Vars.cury = str.slice(0, 4);

                        str = data_b.getMaximumDate();
                        Vars.maxy = str.slice(0, 4);

                        var date = new Date;
                        Vars.mind = date.getDate()
                        Vars.minm = date.getMonth() + 1
                        Vars.miny = date.getFullYear()
                        menuItem.nextPage = url //changes main page unless it's quit button
                    }

                }
            }
            hoverEnabled: true
        }
        Rectangle{
            implicitHeight: buttonLabel.height
            width: parent.width
            color: "transparent"

            anchors{
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: image.height/2
            }

            Text {
                id: buttonLabel
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                text: name
                color: "black"
                font.pixelSize: 18
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                styleColor: "white"
                style: Text.Raised
            }
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
