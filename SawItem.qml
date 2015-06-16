import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import "Variables.js" as Vars

Rectangle {

    property bool edited_f: false
    id: container
    height: 100
    width: parent.width
    color: "#efefef"
    border.color: Vars.bdcolor
    border.width: 2
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Rectangle{
        id: workarea
        height: parent.height
        width: container.width - 70
        color: "transparent"

        //main visualisation of order input

        Text{
            height: parent.height
            width: parent.width - pict.width
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            minimumPixelSize: 20
            font.pixelSize: parent.height/2
            fontSizeMode: Text.Fit
            text: orderModel.get(index).element.get(1).value + " х " +
                  orderModel.get(index).element.get(2).value + " (" + //3
                  orderModel.get(index).element.get(3).value + ")"; //4
        }

        Image{
            id: pict
            anchors{
                right: parent.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }
            height: 70
            width: 70
            source: {
                (orderModel.get(index).element.get(4).value == "false") ? //6
                            "images/onesided.png" : "images/twosided.png"
            }
        }

        MessageDialog{
            id: inf_dialog
            standardButtons: StandardButton.Ok
            function show() {
                var data = "";
                var cur_price;

                var temp = orderModel.get(index).element
                //var area_str = "";
                var area = temp.get(1).value * temp.get(2).value / 10000;

                var am = temp.get(3).value;
                var group = data_b.materialToGroupSaw(temp.get(6).cb_ind)
                var tool = temp.get(7).cb_ind
                cur_price = area*am*data_b.getPriceSaw(tool, group);


                data += "<b>Глубина:</b> " + temp.get(1).value + " см<br><br>";
                data += "<b>Длина:</b> " + temp.get(2).value + " см<br><br>";
                //data += "<b>Площадь:</b> " + temp.get(3).value + " м<sup>2</sup><br><br>";
                data += "<b>Площадь:</b> " + area + " м<sup>2</sup><br><br>";
                data += "<b>Количество:</b> " + temp.get(3).value + "<br><br>";
                data += "<b>Доступ с 2х сторон:</b> " + ((temp.get(4).value == "true") ? "Да" : "Нет") + "<br><br>";
                data += "<b>Материал:</b> " + data_b.idToMaterialSaw(temp.get(6).cb_ind) + "<br><br>";
                data += "<b>Инструмент:</b> " + data_b.idToTool(temp.get(7).cb_ind) + "<br><br>";

                if(temp.get(8).value == "true"){
                    data += "<b>Корректирующий коэффициент:</b> " +  temp.get(8).ext + "<br>";
                    if(temp.get(8).comment != "")
                        data += temp.get(8).comment + "<br>"
                    data += "<br>"
                }

                data += "<center>~~~~~~~~~~</center><br>";
                var m = Math.pow(10,2);
                cur_price = Math.round(cur_price*m)/m;
                data += "<b>Общая цена:</b> " +  cur_price + "<br>";
                if(temp.get(8).value == "true"){
                    cur_price = cur_price * temp.get(8).ext;
                    cur_price = Math.round(cur_price*m)/m;
                }
                data += "<b>С учетом коэффициентов:</b> " +  cur_price + "<br>";
                cur_price = cur_price/am;
                cur_price = Math.round(cur_price*m)/m;
                data += "<br><b>Цена 1 отверстия:</b> " +  cur_price + "<br>";

                inf_dialog.text = data;
                inf_dialog.open();
            }
        }

    }
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    Image{
        id: img_e
        anchors.verticalCenter: parent.verticalCenter
        x: container.width - 60
        height: 60
        width: height
        source: "images/options.png"
        state: "hided"
    }

    Image{
        id: img_d
        anchors.verticalCenter: parent.verticalCenter
        height: 60
        width: height
        source: "images/delete.png"
        state: "hided"

        states: [
            State{
                name: "hided";
                PropertyChanges { target: img_d; x: container.width}
                PropertyChanges { target: img_e; x:container.width - 60}
            },
            State{
                name: "showed";
                PropertyChanges { target: img_d; x: container.width - edit_b.width/2 - img_d.width/2}
                PropertyChanges { target: img_e; x:container.width}
            }
        ]

        transitions: Transition {
            from: "hided"; to: "showed"; reversible: true
            NumberAnimation { properties: "x"; duration: 150; easing.type: Easing.Linear }
        }
    }

    MessageDialog{
        id: mdialog
        standardButtons: StandardButton.Yes | StandardButton.No
        function show() {
            mdialog.text = "Удалить элемент?";
            mdialog.open();
        }

        onYes: {
            edited_f = false; orderModel.remove(index);
            if(orderModel.count == 0)
                Vars.added_f = false //making able to go to main screen from adding if there's no elements
        }
    }

    MouseArea{ //main field
        anchors.left: parent.left
        height: parent.height
        width: parent.width - edit_b.width
        onClicked: {
            if(edited_f){
                edited_f = false;
                img_d.state = "hided"
            }
            else{
                inf_dialog.show();
            }
        }
    }

    Rectangle{
        id: edit_b
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        height: parent.height
        width: height
        color: "transparent"

        MouseArea{
            id: ma
            anchors.fill: parent
            onClicked: {
                if(!edited_f){
                    edited_f = true
                    img_d.state = "showed"
                }
                else
                    mdialog.show();
            }
        }
    }
}

