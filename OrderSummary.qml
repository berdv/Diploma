import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.3
import "Variables.js" as Vars

Item{
    property Loader loader
    property int from
    property Item menuItem

    id: root
    anchors.fill: parent;

    //######################################Main view with holes##############################

    Rectangle {
        id: menurec

        border.width: 2
        border.color: Vars.bdcolor

        color: Vars.bgcolor

        width: parent.width
        height: parent.height - 100
        anchors.bottom: parent.bottom

        ListView{
            id: list_v
            width: menurec.width
            height: menurec.height - 100
            anchors.top: menurec.top
            model: orderModel
            delegate: OrderSummaryDelegate{id: osd; type: from}

            displaced: Transition {NumberAnimation { properties: "y"; duration: 130 } }

            onCountChanged: menurec.getPrice()

            ScrollBar{ anchors.fill: parent; scrollArea: parent}
        }

        Rectangle{
            z: 1
            anchors.bottom: menurec.bottom
            width: menurec.width
            height: 100
            color: Vars.bgcolor//"#efefef"
            Rectangle{width: parent.width; height: 2; color: Vars.bdcolor; anchors.top: parent.top}
            Text {
                id: sum_lbl
                text: "Суммарная стоимость:"
                width: parent.width
                height: parent.height/2.5
                anchors.top: parent.top
                font.pixelSize: 28
                font.bold: true
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
            }

            Text {
                id: sum
                width: parent.width
                anchors.top: sum_lbl.bottom
                anchors.bottom: parent.bottom
                font.pixelSize: parent.height/2.4
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
                minimumPixelSize: 30
                fontSizeMode: Text.Fit
                text: "0р"
            }
        }

        function getPrice(){
            var cnt = orderModel.count
            var price = 0, cur_price = 0;
            var m = Math.pow(10,2);
            var am, temp, i, sum_ratio;
            if(cnt == 0){
                sum.text = "---"
                return;
            }

            //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            if(Vars.cur_type == 0){
                cnt = orderModel.count
                price = 0;
                var j;
                for(j=0; j<cnt; j++){
                    temp = orderModel.get(j).element
                    cur_price = 0;
                    sum_ratio = 1;
                    var diam = data_b.idToDiameter(temp.get(1).cb_ind);
                    am = temp.get(3).value;
                    var gr = data_b.materialToGroupDrill(temp.get(4).cb_ind);

                    for(i=6; i<=15; i++){
                        if(temp.get(i).value == "true")
                            sum_ratio = sum_ratio + (temp.get(i).ext - 1);
                    }

                    for(i=17; i<=20; i++){
                        if(temp.get(i).value == "true")
                            sum_ratio = sum_ratio + (temp.get(i).ext - 1);
                    }

                    cur_price = am * data_b.getPriceDrill(gr, diam) * sum_ratio * temp.get(2).value;
                    cur_price = Math.round(cur_price*m)/m;
                    console.log("CUR_PRICE: " + cur_price)
                    price = price + cur_price;
                }
                if(price < 3000)
                    price = 3000
                sum.text = price + " р";
            }

            //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


            else{
                cnt = orderModel.count
                for(i=0; i<cnt; i++){
                    //data_b.getPriceSaw(tool, group) * depth * length / 10000
                    temp = orderModel.get(i).element
                    //var area_str = "";
                    var area = temp.get(1).value * temp.get(2).value / 10000;
                    am = temp.get(3).value;
                    var group = data_b.materialToGroupSaw(temp.get(6).cb_ind)
                    var tool = temp.get(7).cb_ind
                    cur_price = area*am*data_b.getPriceSaw(tool, group);
                    if(temp.get(8).value == "true")
                         cur_price = cur_price * temp.get(8).ext

                    cur_price = Math.round(cur_price*m)/m;
                    price = price + cur_price;
                }
                if(price < 3000)
                    price = 3000
                sum.text = price + " р"
            }
        }

        Component.onCompleted: getPrice();

    }

    //##########################################################################################

    //######################################Controls with button################################
    Rectangle{
        id: controls

        width: parent.width
        height: 100
        //anchors.bottom: parent.bottom
        anchors.top: parent.top
        border.width: 2
        border.color: "#20202020"
        color: Vars.bgcolor

        //button for extra hole
        Rectangle{
            id: lap_btn
            radius: 20//height/4
            height: parent.height - 10
            width: parent.width/2 - 10
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            border.color: Vars.bdcolor

            gradient: Gradient{
                GradientStop { position: 0 ; color: lap_ma.pressed ? "#ccc" : "#fff"
                    Behavior on color {
                        ColorAnimation{
                            duration: 250
                        }
                    }
                }
                GradientStop { position: 1 ; color: lap_ma.pressed ? "#fff" : "#ccc"
                    Behavior on color {
                        ColorAnimation{
                            duration: 250
                        }
                    }
                }
            }

            MouseArea{
                id: lap_ma
                anchors.fill: parent
                onClicked: {
                    if(!from){ //drill order
                        loader.source = "qrc:/DrillSetup.qml"
                        Vars.cur_type = 0;
                    }
                    else{ //saw order
                        loader.source = "qrc:/SawSetup.qml"
                        Vars.cur_type = 1;
                    }
                }
            }

            Rectangle{
                width: parent.width - lap_img.width + 15
                height: parent.height
                //border.width: 1
                anchors{
                    verticalCenter: lap_btn.verticalCenter
                    right: parent.right
                    rightMargin: 5
                }
                color: "transparent"
                Text {
                    text: "Добавить"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.centerIn: parent.Center
                    font.pixelSize: lap_btn.height/3.5
                    minimumPixelSize: 20
                    fontSizeMode: Text.Fit

                }
            }

            Image{
                id: lap_img
                anchors.left: parent.left
                anchors.verticalCenter: lap_btn.verticalCenter
                anchors.leftMargin: -10
                height: lap_btn.height - 10
                width: height
                source: "images/arrowprev.png"
            }
        }

        //button for finishing
        Rectangle{
            id: end_btn
            radius: 20//height/4
            height: parent.height - 10
            width: parent.width/2 - 10
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            border.color: Vars.bdcolor

            gradient: Gradient{
                GradientStop { position: 0 ; color: end_ma.pressed ? "#ccc" : "#fff"
                    Behavior on color { ColorAnimation{ duration: 250 } }
                }
                GradientStop { position: 1 ; color: end_ma.pressed ? "#fff" : "#ccc"
                    Behavior on color { ColorAnimation{ duration: 250 } } }
            }

            MouseArea{
                id: end_ma
                anchors.fill: parent

                MessageDialog{
                    id: mdialog
                    standardButtons: StandardButton.Ok
                    function show(){
                        mdialog.text = "Заказ пуст!";
                        mdialog.open();
                    }
                }

                onClicked: {
                    if(orderModel.count){
                        loader.source = "qrc:/OrderPublishing.qml";
                        loader.item.loader = loader;
                        loader.item.from = from
                    }
                    else
                        mdialog.show();
                }
            }

            Rectangle{
                width: parent.width - end_img.width + 15
                height: parent.height
                anchors{
                    verticalCenter: end_btn.verticalCenter
                    left: end_btn.left
                    leftMargin: 5
                }
                color: "transparent"
                Text {
                    text: "Опубликовать"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: end_btn.height/3.5
                    minimumPixelSize: 20
                    fontSizeMode: Text.Fit
                }
            }

            Image{
                id: end_img
                anchors.right: end_btn.right
                anchors.rightMargin: -10
                anchors.verticalCenter: end_btn.verticalCenter
                height: end_btn.height - 10
                width: height
                source: "images/arrownext.png"
            }

        }

    }

    Component.onCompleted: {
        console.log("Component.onCompleted -- OrderSummary: " + root)
    }
    Component.onDestruction: {
        console.log("Component.onDestruction -- OrderSummary: " + root)
    }
}
