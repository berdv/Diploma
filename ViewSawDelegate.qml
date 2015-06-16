import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import "Variables.js" as Vars

Rectangle {
    property bool edited_f: false
    signal delOrderS()
    id: container
    width: bill_v.width
    height: mainarea.height
    color: "#efefef"

    Rectangle{color: Vars.bdcolor; height: 1; width: parent.width; anchors.top: parent.top}
    Rectangle{color: Vars.bdcolor; height: 1; width: parent.width; anchors.bottom: parent.bottom}

    MouseArea{
        id: main_ma
        height: container.height
        width: container.width - 80

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
        id: mainarea
        color: "transparent"
        width: container.width - 80
        height: 120

        anchors{
            left: parent.left
            verticalCenter: container.verticalCenter
        }

        Image{
            id: pic
            width: 90
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 5
            source: (twosided == "true") ? "images/twosided.png" : "images/onesided.png"
        }


        Text{
            id: txt
            height: parent.height
            width: parent.width - pic.width - 5
            anchors.left: pic.right
            anchors.leftMargin: 5
            minimumPixelSize: 20
            font.pixelSize: parent.height/2
            fontSizeMode: Text.Fit
            text: depth + " х " + length + " (" + amount + ")";
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
        }
    }

    MouseArea{
        anchors.right: container.right
        width: 80
        height: container.height

        onClicked: {
            if(!edited_f){
                edited_f = true
                img_d.state = "showed"
            }
            else{
                mdialog.show();
            }
        }
    }

    Image{
        id: img_e
        anchors.verticalCenter: container.verticalCenter
        x: container.width - 40
        height: 70
        width: height
        source: "images/options.png"
        state: "hided"
    }

    Image{
        id: img_d
        anchors.verticalCenter: container.verticalCenter
        height: 70
        width: height
        source: "images/delete.png"
        state: "hided"

        states: [
            State{
                name: "hided";
                PropertyChanges { target: img_d; x: container.width + 20}
                PropertyChanges { target: img_e; x: container.width - 65}
            },
            State{
                name: "showed";
                PropertyChanges { target: img_d; x: container.width - 72}
                PropertyChanges { target: img_e; x: container.width + 20}
            }
        ]

        transitions: Transition {
            from: "hided"; to: "showed"; reversible: true
            NumberAnimation { properties: "x"; duration: 150; easing.type: Easing.Linear }
        }
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Delete confirmation~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    MessageDialog{
        id: mdialog
        standardButtons: StandardButton.Yes | StandardButton.No
        function show() {
            if(certainModel.count >1)
                mdialog.text = "Удалить элемент заказа?\nЭто действие нельзя отменить.";
            else
                mdialog.text = "Удалить элемент?\nЭто единственный элемент заказа, его удаление приведет к удалению заказа. Продолжить?";
            mdialog.open();
        }

        onYes: {
            edited_f = false;
            if(certainModel.count == 1)
                Vars.del_f = true
            data_b.delSawBill(id_bill);
            viewModel.setProperty(Vars.cur_v_ind, "count", viewModel.get(Vars.cur_v_ind).count - 1);
            certainModel.remove(index);
            //data_b.delSawBill();
        }
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~INFORMATION DIALOG~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    MessageDialog{
        id: inf_dialog
        standardButtons: StandardButton.Ok
        function show() {
            var data = "";
            var i;

            data += "<b>Глубина:</b> " + depth + " см<br><br>";
            data += "<b>Длина:</b> " + length + " см<br><br>";
            data += "<b>Площадь:</b> " + area + " м<sup>2</sup><br><br>";
            data += "<b>Количество:</b> " + amount + "<br><br>";
            data += "<b>Доступ с 2х сторон:</b> " + ((twosided == "true") ? "Да" : "Нет") + "<br><br>";
            data += "<b>Группа материалов:</b> " + group + "<br><br>";
            data += "<b>Инструмент:</b> " + data_b.idToTool(group) + "<br><br>";
            if(ratio != 1){
                data += "<b>Корректирующий коэффициент:</b> " +  ratio + "<br>";
                if(comment != "")
                    data += comment + "<br>"
                data += "<br>"
            }

            var m = Math.pow(10,2);

            var price_sum = price * amount;
            var price_sum_r = price_sum * ratio;
            var each_price = price * ratio

            price_sum_r = Math.round(price_sum_r*m)/m;
            each_price = Math.round(each_price*m)/m;


            data += "~~~~~~~~~~~~~~~~~~~~~~~~~~~<br>";
            data += "<b>Цена: </b>" + price_sum + "р<br>";
            data += "<b>   C учетом коэффициента: </b>" + price_sum_r + "р<br>";
            data += "<b>Цена 1 проема: </b>" + each_price + "р<br>";

            inf_dialog.text = data;
            inf_dialog.open();
        }
    }
}

