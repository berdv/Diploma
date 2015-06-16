import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtGraphicalEffects 1.0
import "Variables.js" as Vars

import DB 1.0

Item{
    property Loader loader
    property int from: Vars.cur_type
    property Item menuItem
    property int check: 0

    id: root
    anchors.fill: parent;
    anchors.centerIn: parent;


    Rectangle{
        id: workarea
        color: "red"//Vars.bgcolor
        width: parent.width;
        height: parent.height
        border.width: 2
        border.color: Vars.bdcolor

        Flickable{ //Main screen flickable area

            id: flck
            property int scramount: Vars.d_elements

            anchors.fill: parent
            width: workarea.width
            height: workarea.height

            contentWidth: workarea.width;//*scramount;
            contentHeight: workarea.height;
            interactive: false

            //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

            Keys.onReleased: {
                if (event.key == Qt.Key_Back) {
                    event.accepted = false
                    loader.source = "qrc:/OrderSummary.qml";
                    loader.item.loader = loader;
                    loader.item.from = Vars.cur_type;
                }
            }

            ScreenForm{
                id: d_scr1
                width: workarea.width
                position: 0
                Component.onCompleted: {
                    var i;
                    addItem("Данные о заказе", "Splitter");
                    addItem_t("ФИО/Организация<font color=\"#ff4242\">*</font>", "TextInput", "required")
                    addItem_t("Адрес<font color=\"#ff4242\">*</font>", "TextInput", "required")
                    addItem_t("Телефон", "TextInput", "")

                    addItem("Разместить", "Control");
                }

                MessageDialog{
                    id: mdialog
                    standardButtons: StandardButton.Ok
                    function show() {
                        mdialog.text = "Заказ добавлен";
                        mdialog.open();
                    }

                    onAccepted: {
                        Vars.started_f = false
                        menuItem.nextPage = "";
                    }
                }

                onNextScreenCall: {
                    if(!check){
                        getItems();
                        var Array =[], Data = [], Bill = [];
                        var customer_id, bill_id, options_id, i, j;
                        var temp;
                        Array.push(commonModel.get(1).value, commonModel.get(2).value, commonModel.get(3).value);
                        customer_id = data_b.addCustomer(Array);

                        //make loop for orderModel's elements and take it into convenient 'if'
                        if(!from){ //should be !form
                            for(j=0; j<orderModel.count; j++){
                                temp = orderModel.get(j).element;


                                Data.push(data_b.idToDiameter(temp.get(1).cb_ind));
                                Data.push(temp.get(2).value);
                                Data.push(temp.get(3).value);
                                Data.push(temp.get(4).cb_ind);

                                bill_id = data_b.getDrillBillId();
                                Bill.push(bill_id);
                                data_b.addDrillBill(Data, bill_id);
                                Data = [];

                                for(i=6; i<=15; i++){
                                    if(temp.get(i).value == "true"){
                                        Data.push(i-5);
                                        Data.push(temp.get(i).ext);
                                        Data.push(temp.get(i).comment);
                                    }
                                }

                                for(i=17; i<=20; i++){
                                    if(temp.get(i).value == "true"){
                                        Data.push(i-6);
                                        Data.push(temp.get(i).ext);
                                        Data.push(temp.get(i).comment);
                                    }
                                }

                                data_b.addDrillExtraCost(Data, bill_id);//extracost_id);
                                Data = [];
                            }

                            options_id = data_b.addDrillOptions(Bill);

                            data_b.addDrillOrder(options_id, customer_id);

                        }

                        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        //~~~~~~~~~~~~~~~~Saw order adding~~~~~~~~~~~~~~~~~~~~~~
                        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                        else{
                            var area;
                            for(j=0; j<orderModel.count; j++){
                                temp = orderModel.get(j).element;
                                area = temp.get(1).value * temp.get(2).value / 10000;


                                Data.push(temp.get(1).value); //depth
                                Data.push(temp.get(2).value); //length
                                Data.push(area); //area
                                Data.push(temp.get(3).value); //amount
                                Data.push(temp.get(4).value); //two_sided
                                Data.push(temp.get(7).cb_ind); //id_tool
                                Data.push(temp.get(6).cb_ind); //material
                                Data.push(temp.get(8).value); //ratio
                                if(temp.get(8).value == "true"){
                                    Data.push(temp.get(8).ext); //ratio value
                                    Data.push(temp.get(8).comment); //comment
                                }

                                console.log("DATA: " + Data);

                                bill_id = data_b.getSawBillId();
                                Bill.push(bill_id);
                                data_b.addSawBill(Data, bill_id);
                                Data = [];
                            }
                            options_id = data_b.addSawOptions(Bill);
                            data_b.addSawOrder(options_id, customer_id);
                            console.log("lap")
                        }

                        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        var str = data_b.getMinimumDate();
                        Vars.curd = str.slice(8, 10);
                        Vars.curm = str.slice(5, 7);
                        Vars.cury = str.slice(0, 4);
                        Vars.mind = str.slice(8, 10);
                        Vars.minm = str.slice(5, 7);
                        Vars.miny = str.slice(0, 4);
                        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                        mdialog.show()
                    }
                }
                //onNextScreenAck: { }
            }
        }

    }


    Component.onCompleted: {
        console.log("Component.onCompleted -- OrderPublishing: " + root)
    }
    Component.onDestruction: {
        console.log("Component.onDestruction -- OrderPublishing: " + root)
    }

}
