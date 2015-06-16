import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtGraphicalEffects 1.0
import "Variables.js" as Vars

Item{

    property Item menuItem
    property int check: 0
    property int from;

    id: root
    anchors.fill: parent;
    anchors.centerIn: parent;

    signal orderComplete(int from);
    signal takeFromFirst;
    signal takeFromSecond;
    signal takeFromThird;

    visible: true

    onTakeFromFirst: {scr1.takeData()}
    onTakeFromSecond: {scr2.takeData()}

    Rectangle{
        id: nav

        property int navamount: Vars.s_elements
        z: 2

        border.color: Vars.bdcolor
        border.width: 2
        color: "#d5d5d5"

        width: root.width; height: root.height/9
        anchors.top: root.top

        NavButton{
            id:nav_b0
            position: 0
            activated: true
            onButtonClicked: {flck.contentX = 0}
        }

        NavButton{
            id:nav_b1
            position: 1
            onButtonClicked: {flck.contentX = (flck.visibleArea.widthRatio * flck.contentWidth)*position}
        }
    }

    Rectangle{
        id: workarea
        color: Vars.bgcolor//"transparent"
        anchors.top: nav.bottom
        anchors.topMargin: 1
        width: parent.width; height: parent.height - nav.height - 2


        Flickable{ //Main screen flickable area

            id: flck

            property int scramount: Vars.s_elements
            signal widthchanged;

            anchors.fill: parent
            width: workarea.width
            height: workarea.height

            contentWidth: workarea.width
            contentHeight: workarea.height;
            interactive: true
            flickableDirection: Flickable.HorizontalFlick
            boundsBehavior: Flickable.StopAtBounds

            onWidthChanged: { contentX = (visibleArea.widthRatio * contentWidth)*Vars.cur_scr }

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

            maximumFlickVelocity: 150
            property real initContentX
            property real initElementNumber

//            onMovementStarted:
//            {
//                //save contentX to a custom property on your flickable
//                initContentX = contentX
//                //also save current element number
//                initElementNumber = contentX / workarea.width
//            }

//            onMovementEnded:
//            {
//                var numberOfItem = Math.round((contentX - initContentX) /(workarea.width*0.6));
//                contentX = (workarea.width * numberOfItem)
//                        + (initElementNumber * workarea.width)
//            }
            onMovementStarted: {
                Vars.cur_scr = Math.floor((visibleArea.xPosition * contentWidth)/width); //current screen number
                Vars.start_pos = Math.floor(100*(((visibleArea.xPosition * contentWidth)/width)%1)) // position on screen
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
                widthchanged()
            }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

            Behavior on contentX { NumberAnimation{ duration: 130}}


            ScreenForm{
                id: scr1
                position: 0
                width: workarea.width
                Component.onCompleted: {
                    addItem("Параметры проема", "Splitter")
                    addItem_n("Глубина (см)", "NumInput", "double");
                    addItem_n("Длина (см)", "NumInput", "double");
                    //addItem_n("Площадь (кв.м)", "NumInput", "double");
                    addItem_n("Количество", "NumInput", "int");
                    addItem("Доступ с 2х сторон", "CheckBox")
                    addItem("Далее", "Control");
                }

                onNextScreenCall: {
                    nav_b1.activated = true;
                    flck.contentX = (flck.visibleArea.widthRatio * flck.contentWidth)*(position+1)
                    scr2.visible = true
                    flck.contentWidth = workarea.width*2;
                }

                onNextScreenAck: {takeFromSecond()}
            }


            ScreenForm{
                id: scr2
                visible: false
                position: 1
                width: workarea.width
                Component.onCompleted: {
                    addItem("Информация о заказе", "Splitter")
                    addItem_l("Материал", "ComboBox", data_b.getMaterialSaw());
                    addItem_l("Инструмент", "ComboBox", data_b.getTools());
                    //addItem_n("Корректирующий коэффициент", "NumInput", "double");
                    addItem_e("Корректирующий коэффициент", "CheckBoxE", 1);
                    addItem("Завершить", "Control");
                }

                onNextScreenCall: {
                    //takeData()
                    takeFromFirst()
                }

                onNextScreenAck: {
                    orderComplete(1)
                }
            }
        }
    }
}
