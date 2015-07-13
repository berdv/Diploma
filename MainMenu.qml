import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.3
import QtGraphicalEffects 1.0
import "Variables.js" as Vars

//Item{
Rectangle{
    id: mainmenu

    property Item page: ei

    anchors.fill: parent
    color: Vars.bgcolor

    MessageDialog{
        id: mdialog
        function show(warning) {
            mdialog.text = warning;
            mdialog.open();
        }
    }

    Keys.onReleased: {
        if (event.key == Qt.Key_Back) {
            event.accepted = true
        }
    }


    function addButton(name, desc, pic, url)
    {
        menuModel.append({"name":name, "description":desc, "pic": pic ,"url":url})
    }

    function hideButton()
    {
        ei.visible = false;
    }

    ListView {
        id: buttons
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        snapMode: ListView.SnapToItem
        delegate: MainMenuDelegate{menuItem: ei}
        model: ListModel {id: menuModel}

        width: (parent.height>parent.width) ? parent.width : 140
        height: (parent.height>parent.width) ? 140: parent.height
        anchors.bottom: parent.bottom
        orientation: (parent.height>parent.width) ? Qt.Horizontal : Qt.Vertical
    }

    Rectangle{
        color: "#e3e3e3"
        anchors.left: (parent.height>parent.width) ? parent.left : buttons.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: (parent.height>parent.width) ? buttons.top : parent.bottom;
        width: parent.width

        Rectangle{
            id: logo
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenterOffset: -30
            height: parent.height > parent.width ? parent.width/1.5 : parent.height/1.5
            width: height
            color: "transparent"
            Image{
                anchors.fill: parent
                source: "images/icon2.png"
            }

            Rectangle{
                anchors.top: logo.bottom
                anchors.topMargin: 10
                width: mainmenu.width
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                height: 80
                Text{
                    width: parent.width
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    text: "V 1.1"
                    minimumPixelSize: 40
                    fontSizeMode: Text.Fit
                    font.pixelSize: parent.height/2
                }
            }
        }

        Item {

            property url nextPage
            property url prevPage: ""

            id: ei
            visible: nextPage != ''
            clip: true

            anchors.fill: parent

            Rectangle {
                id: bg
                anchors.fill: parent
            }

            //Eats mouse events
            MouseArea{
                anchors.fill: parent
                enabled: ei.visible
            }
            Loader{
                width: parent.width
                height: parent.height - 140
                anchors.top: parent.top
                id: mainloader
                focus: true
                source: ei.nextPage
                anchors.fill: parent

                onLoaded: {
                    if(source == "qrc:/AddMenu.qml")
                        item.pageItem = ei
                }

                onSourceChanged: {
                    Vars.added_f = false
                }
            }
        }
    }

}
