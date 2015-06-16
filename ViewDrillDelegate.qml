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
        width: container.width - 70

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
            leftMargin: 5
            verticalCenter: container.verticalCenter
        }


        Text{
            id: txt
            width: parent.width
            height: parent.height
            anchors.left: parent.left
            minimumPixelSize: 20
            font.pixelSize: parent.height/1.8
            fontSizeMode: Text.Fit
            text: "∅" + diameter + " х " + depth + " (" + amount + ")";
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
            data_b.delDrillBill(id_bill);
            viewModel.setProperty(Vars.cur_v_ind, "count", viewModel.get(Vars.cur_v_ind).count - 1);
            certainModel.remove(index);
        }
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~INFORMATION DIALOG~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    MessageDialog{
        id: inf_dialog
        standardButtons: StandardButton.Ok
        function show() {
            var data = "", Ratios = [];
            var i, res_ratio = 1;

            data += "<b>Диаметр (мм):</b> " + diameter + " &#8709;<br><br>";
            data += "<b>Глубина (см):</b> " + depth + "<br><br>";
            data += "<b>Количество:</b> " + amount + "<br><br>";
            data += "<b>Группа материалов :</b> " + group + "<br><br>";
            var issmth = 0;

            //options_id = Vars.cur_v_ind

            data += "<br><center><b>Корректирующие коэффициенты</b></center><br><br>"
            Ratios = data_b.getDrillRatios(id_bill);

            for(i=0; i<Ratios.length; i = i +3){
                data += "<b>" + Ratios[i] + ": </b>";
                data += Ratios[i+1] + "<br>";
                if(Ratios[i+2] != "")
                    data += Ratios[i+2] + "<br>";
                data += "<br>"
                res_ratio = res_ratio + (Ratios[i+1] - 1);
            }

            data += "<b>  Итоговый коэффициент: </b>" + res_ratio + "<br><br>"

            var m = Math.pow(10,2);
            var price_sum = price;// * amount;
            var price_sum_r = price_sum * res_ratio;
            var each_price = price * res_ratio / amount;

            price_sum_r = Math.round(price_sum_r*m)/m;
            each_price = Math.round(each_price*m)/m;

            data += "~~~~~~~~~~~~~~~~~~~~~~~~~~~<br>";
            data += "<b>Цена: </b>" + price_sum + "р<br>";
            data += "<b>   C учетом коэффициента: </b>" + price_sum_r + "р<br>";
            data += "<b>Цена 1 отверстия: </b>" + each_price + "р<br>";


            inf_dialog.text = data;
            inf_dialog.open();
        }
    }

}

