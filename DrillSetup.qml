import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtGraphicalEffects 1.0
import "Variables.js" as Vars

import DB 1.0

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

    onTakeFromFirst: {d_scr1.takeData()}
    onTakeFromSecond: {d_scr2.takeData()}
    onTakeFromThird:  {d_scr3.takeData()}

    visible: true

    Rectangle{anchors.fill: parent; color: "#e3e3e3"}

    Rectangle{
        id: nav

        property int navamount: Vars.d_elements
        z: 1

        border.color: Vars.bdcolor
        border.width: 2
        color: "#d5d5d5"

        width: root.width; height: root.height/10
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

        NavButton{
            id:nav_b2
            position: 2
            onButtonClicked: {flck.contentX = (flck.visibleArea.widthRatio * flck.contentWidth)*position}
        }

    }

    Rectangle{
        id: workarea
        color: Vars.bgcolor//"transparent"
        anchors.top: nav.bottom
        width: parent.width; height: parent.height - nav.height

        Flickable{ //Main screen flickable area

            id: flck

            property int scramount: Vars.d_elements

            //anchors.fill: parent
            width: workarea.width
            height: workarea.height

            contentWidth: workarea.width;//*scramount;
            contentHeight: workarea.height;
            interactive: true
            flickableDirection: Flickable.HorizontalFlick
            boundsBehavior: Flickable.StopAtBounds

            //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

            maximumFlickVelocity: 150
            property real initContentX
            property real initElementNumber

            //onWidthChanged: { contentX = (visibleArea.widthRatio * contentWidth)*Vars.cur_scr}

            onWidthChanged: {
//                var numberOfItem = Math.round((contentX - initContentX) / workarea.width);
//                flck.contentWidth = workarea.width*(Vars.cur_scr + 1)
//                contentX = (workarea.width * numberOfItem)
//                        + (initElementNumber * workarea.width)
            }

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
                //widthChanged()
            }

            //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

            Behavior on contentX { NumberAnimation{ duration: 130}} //Animation for changing flickable's X position

//            Keys.onReleased: {
//                if (event.key == Qt.Key_Back) {
//                    event.accepted = false

//                    Vars.cur_scr = (Vars.cur_scr) ? Vars.cur_scr - 1 : Vars.cur_scr
//                    flck.contentX = (flck.visibleArea.widthRatio * flck.contentWidth)*Vars.cur_scr;

//                }
//            }

            ScreenForm{
                id: d_scr1
                width: workarea.width
                position: 0
                Component.onCompleted: {
                    addItem("Параметры отверстий", "Splitter");
                    addItem_l("Диаметр (мм)", "ComboBox", data_b.getDiameter());
                    addItem_n("Глубина (см)", "NumInput", "double");
                    addItem_n("Количество", "NumInput", "int");
                    addItem_l("Материал", "ComboBox", data_b.getMaterialDrill());

                    addItem("Далее", "Control");
                }


                onNextScreenCall: {
                    nav_b1.activated = true;
                    Vars.cur_scr = position + 1;
                    d_scr2.visible = true
                    flck.contentWidth = workarea.width*2
                    flck.contentX = (flck.visibleArea.widthRatio * flck.contentWidth)*(position+1)
                }

                onNextScreenAck: {takeFromSecond()}
            }

            ScreenForm{
                id: d_scr2
                width: workarea.width
                position: 1
                visible: false
                Component.onCompleted: {
                    addItem("Корректирующие коэффициенты", "Splitter");
                    addItem_e("Использование пылесоса", "CheckBoxE", data_b.getRatioValDrill(1));
                    addItem_e("Диаметр от 62 мм при глубине бурения от 100 см", "CheckBoxE", data_b.getRatioValDrill(2));
                    addItem_e("Бурение под углом 45-90 град.", "CheckBoxE", data_b.getRatioValDrill(3));
                    addItem_e("Бурение снизу-вверх", "CheckBoxE", data_b.getRatioValDrill(4));
                    addItem_e("Бурение на высоте выше 2х метров от уровня пола", "CheckBoxE", data_b.getRatioValDrill(5));
                    addItem_e("Бурение с автовышки", "CheckBoxE", data_b.getRatioValDrill(6));
                    addItem_e("Ограниченный доступ", "CheckBoxE", data_b.getRatioValDrill(7));
                    addItem_e("Сильно армированный бетон", "CheckBoxE", data_b.getRatioValDrill(8));
                    addItem_e("Бетон марки 300 и выше", "CheckBoxE", data_b.getRatioValDrill(9));
                    addItem_e("Бурение без подъемника выше 5 этажа", "CheckBoxE", data_b.getRatioValDrill(10));

                    addItem("Далее", "Control");
                }

                onNextScreenCall: {
                    nav_b2.activated = true;
                    Vars.cur_scr = position + 1;
                    d_scr3.visible = true
                    flck.contentWidth = workarea.width*3
                    flck.contentX = (flck.visibleArea.widthRatio * flck.contentWidth)*(position+1)
                }

                onNextScreenAck: {takeFromThird()}
            }

            ScreenForm{
                id: d_scr3
                width: workarea.width
                position: 2
                visible: false
                Component.onCompleted: {
                    addItem("Прочие коэффициенты", "Splitter");
                    addItem_e("Температура ниже 0 град. (закрытый контур)", "CheckBoxE", data_b.getRatioValDrill(11));
                    addItem_e("Работа выходные/праздничные дни", "CheckBoxE", data_b.getRatioValDrill(12));
                    addItem_e("Работа в ночное время", "CheckBoxE", data_b.getRatioValDrill(13));
                    addItem_e("Дополнительный коэффициент", "CheckBoxE", 1.0);
                    addItem("Завершить", "Control");
                }

                onNextScreenCall: {
                    //takeData();
                    takeFromFirst()
                }
                onNextScreenAck: {
                    orderComplete(0)
                }
            }

        }
    }
}
