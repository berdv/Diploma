import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.3
import QtGraphicalEffects 1.0
import "Variables.js" as Vars

Item{

    id: root
    width: parent.width
    height: parent.height;
    anchors.fill: parent;
    anchors.centerIn: parent;

    visible: true

    Rectangle{
        id: nav
        z: 2
        border.color: "lightgrey"; border.width: 1;
        color: "#e0d0c0"
        width: root.width; height: root.height/9
        anchors.top: root.top

        NavButton{
            id:nav_b
            bcolor: "green"
            position: 0
            onButtonClicked: {flck.contentX = 0}
        }

        NavButton{
            id:nav_b2
            bcolor: "green"
            position: 1
            onButtonClicked: {flck.contentX = (flck.visibleArea.widthRatio * flck.contentWidth)}
        }

        NavButton{
            id:nav_b3
            bcolor: "green"
            position: 2
            onButtonClicked: {flck.contentX = (flck.visibleArea.widthRatio * flck.contentWidth)*2}
        }

        NavButton{
            id:nav_b4
            bcolor: "green"
            position: 3
            onButtonClicked: {flck.contentX = (flck.visibleArea.widthRatio * flck.contentWidth)*3}
        }

        NavButton{
            id:nav_b5
            bcolor: "green"
            position: 4
            onButtonClicked: {flck.contentX = (flck.visibleArea.widthRatio * flck.contentWidth)*4}
        }
    }

    Rectangle{
        id: workarea
        color: "transparent"
        anchors.top: nav.bottom
        anchors.topMargin: 1
        width: parent.width; height: parent.height - nav.height - 2

        Flickable{ //Main screen flickable area

            id: flck

            anchors.fill: parent
            width: workarea.width
            height: workarea.height
            contentWidth: workarea.width*Vars.elements;
            contentHeight: workarea.height;
            interactive: true
            flickableDirection: Flickable.HorizontalFlick
            boundsBehavior: Flickable.DragOverBounds
            maximumFlickVelocity: 180


            onMovementStarted: {
                Vars.cur_scr = Math.floor((visibleArea.xPosition * contentWidth)/width); //current screen number
                Vars.start_pos = Math.floor(100*(((visibleArea.xPosition * contentWidth)/width)%1)) // position on screen
                console.log(Vars.start_pos)
            }

            onMovementEnded: {
                var prev_scr = Vars.cur_scr
                Vars.cur_scr = Math.floor((visibleArea.xPosition * contentWidth)/width);
                var end_pos = Math.floor(100*(((visibleArea.xPosition * contentWidth)/width)%1))

                if(Vars.cur_scr === prev_scr){
                    if(end_pos > Vars.start_pos && (end_pos - Vars.start_pos)>Vars.diff)
                        Vars.cur_scr += 1
                }
                else{
                    if(end_pos >(100 - Vars.diff))
                        Vars.cur_scr += 1
                }

                contentX = Vars.cur_scr * (visibleArea.widthRatio * contentWidth)

            }

            Behavior on contentX {
                NumberAnimation{ duration: 200}
            }

            ScreenForm{
                id: scr1
                scolor: "purple"

                Flickable{
                    id: testfl
                    width: parent.width - 30
                    height: parent.height
                    anchors.centerIn: parent


                    contentWidth: width
                    contentHeight: 7*height/5
                    interactive: true

                    Rectangle{
                        id: rec
                        width: parent.width
                        height: scr1.height/5
                        color: "white"
                    }
                    Rectangle{
                        width: parent.width
                        height: scr1.height/5
                        color: "black"
                        y: height
                    }
                    Rectangle{
                        width: parent.width
                        height: scr1.height/5
                        color: "red"
                        y: 2 * height
                    }
                    Rectangle{
                        width: parent.width
                        height: scr1.height/5
                        color: "orange"
                        y: 3 * height
                    }
                    Rectangle{
                        width: parent.width
                        height: scr1.height/5
                        color: "yellow"
                        y: 4 * height
                    }
                    Rectangle{
                        width: parent.width
                        height: scr1.height/5
                        color: "plum"
                        y: 5 * height
                    }
                    Rectangle{
                        width: parent.width
                        height: scr1.height/5
                        color: "magenta"
                        y: 6 * height
                        MouseArea{
                            hoverEnabled: true
                            anchors.fill: parent
                            anchors.centerIn: parent

                            onClicked: Qt.quit()
                        }
                    }

                }
            }

            ScreenForm{
                id: scr2
                scolor: "red"
                position: 1
            }
            ScreenForm{
                id: scr3
                scolor: "orange"
                position: 2
            }
            ScreenForm{
                id: scr4
                scolor: "yellow"
                position: 3

                MouseArea{
                    hoverEnabled: true
                    anchors.fill: parent
                    anchors.centerIn: parent
                }
            }
            ScreenForm{
                id: scr5
                scolor: "green"
                position: 4
                Text{
                    text: "Выход"
                    wrapMode: Text.WordWrap
                    font.pixelSize: 48
                    anchors.centerIn: parent
                }

                MouseArea{
                    hoverEnabled: true
                    anchors.fill: parent
                    anchors.centerIn: parent

                    onClicked: Qt.quit()
                }
            }
        }
    }
}
