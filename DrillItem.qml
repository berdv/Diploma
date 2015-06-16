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
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            minimumPixelSize: 20
            font.pixelSize: parent.height/2
            fontSizeMode: Text.Fit
            text: "∅" + data_b.idToDiameter(orderModel.get(index).element.get(1).cb_ind) + " х " +
                  orderModel.get(index).element.get(2).value + " (" +
                  orderModel.get(index).element.get(3).value + ")";
        }

        MessageDialog{
            id: inf_dialog
            standardButtons: StandardButton.Ok
            function show() {
                var data = "";
                var i;

                var temp = orderModel.get(index).element
                var m = Math.pow(10,2);
                var sum_ratio = 1;
                var cur_price;
                var diam = data_b.idToDiameter(temp.get(1).cb_ind);
                var am = temp.get(3).value;
                var gr = data_b.materialToGroupDrill(temp.get(4).cb_ind);

                data += "<b>Диаметр (мм):</b> " + diam + " &#8709;<br><br>";
                data += "<b>Глубина (см):</b> " + temp.get(2).value + "<br><br>";
                data += "<b>Количество:</b> " + am + "<br><br>";
                data += "<b>Материал :</b> " + data_b.idToMaterialDrill(temp.get(4).cb_ind) + "<br><br>";
                var issmth = 0;

                for(i=6; i<=15; i++){
                    if(temp.get(i).value == "true"){
                        if(!issmth){
                            issmth = 1;
                            data += "<b><center>Коэффициенты</center></b><br><br>"
                        }
                        data += "<b> -" + data_b.getRatioDescDrill(i - 6) + ":</b> ";
                        data += temp.get(i).ext + "<br>";
                        sum_ratio = sum_ratio + (temp.get(i).ext - 1);
                        if(temp.get(i).comment != "")
                            data += temp.get(i).comment + "<br>"
                        data += "<br>"
                    }
                }

                for(i=17; i<=20; i++){
                    if(temp.get(i).value == "true"){
                        if(!issmth){
                            issmth = 1;
                            data += "<b><center>Коэффициенты</center></b><br><br>"
                        }
                        data += "<b> -" + data_b.getRatioDescDrill(i - 7) + ":</b> ";
                        data += temp.get(i).ext + "<br>";
                        sum_ratio = sum_ratio + (temp.get(i).ext - 1);
                        if(temp.get(i).comment != "")
                            data += temp.get(i).comment + "<br>"
                        data += "<br>"
                    }
                }

                data += "<b>Итоговый коэффициет: </b>" + sum_ratio + "<br><br>"

                data += "<center>~~~~~~~~~~</center><br>";
                cur_price = am * data_b.getPriceDrill(gr, diam) * temp.get(2).value;//
                cur_price = Math.round(cur_price*m)/m;
                data += "<b>Общая цена:</b> " +  cur_price + "<br>";
                cur_price = cur_price * sum_ratio;
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
                Vars.added_f = false
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

