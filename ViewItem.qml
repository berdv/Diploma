import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.3
import "Variables.js" as Vars

import DB 1.0

Item {
    id: container
    anchors.fill: parent
//    border.color: Vars.bdcolor
//    border.width: 2
//    color: Vars.bgcolor

//    Keys.onReleased: {
//        console.log("VI keypressed")
//        if (event.key == Qt.Key_Back) {//(event.key == Qt.Key_Escape){
//            event.accepted = false
//        }
//    }

    ListModel{id: viewModel}
    ListModel{id: certainModel
        onCountChanged: {
            if(count == 0 && (Vars.del_f == true)){
                data_b.delOrder(viewModel.get(Vars.cur_v_ind).id_order);
                Vars.del_f = false
                billLoader.source = ""
                viewModel.remove(Vars.cur_v_ind, 1);
                //DataBase order removing function call here
            }
        }
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Rectangle{
        id: viewarea
        width: parent.width
        height: parent.height - 100
        anchors.horizontalCenter: parent.horizontalCenter

        anchors.top: parent.top
        anchors.topMargin: 100
        color: Vars.bgcolor

        Image{
            width: parent.width*0.7
            height: width
            source: "images/empty.png"
            anchors.centerIn: parent
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter

            visible: viewModel.count > 0 ? false : true
        }

        function deleteOrder(){
            billLoader.source = "";
        }

        Loader{
            id: billLoader
            z: 2
            anchors.fill: parent
        }

        ListView{

            id: view_v
            width: viewarea.width
            height: viewarea.height
            boundsBehavior: Flickable.StopAtBounds
            spacing: 10

            model: viewModel

            delegate:  Loader{
                id: viewLoader
                width: parent.width
                source: "ViewDelegate.qml"
            }

            displaced: Transition {NumberAnimation { properties: "y"; duration: 130 } }

            ScrollBar{ anchors.fill: parent; scrollArea: view_v}
        }
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    function getData(){
        var Data = [];
        var d1, d2;
        if(since_button.text != "с"){
            d1 = since_button.year + "-";
            d1 += (since_button.month < 10 ? "0" : "") + since_button.month + "-";
            d1 += (since_button.day < 10 ? "0" : "") + since_button.day;
        }
        else
            d1 = "";
        if(until_button.text != "по"){
            d2 = until_button.year + "-";
            d2 += (until_button.month < 10 ? "0" : "") + until_button.month + "-";
            d2 += (until_button.day < 10 ? "0" : "") + until_button.day;
        }
        else
            d2 = "";

        var i;
        Data = data_b.getOrders(d1,d2);

        viewModel.clear();
        for(i=0; i<Data.length; i+=9){
            viewModel.append({
                                 "id_order": Data[i],
                                 "id_options": Data[i+1],
                                 "id_customer": Data[i+2],
                                 "consumables": Data[i+3],
                                 "price": Data[i+4],
                                 "salary": Data[i+5],
                                 "date": Data[i+6],
                                 "type": Data[i+7],
                                 "count": Data[i+8]
                             });
        }
    }

    Loader{
        z: 2
        id: since_loader
        anchors.fill: container
    }

    Connections{
        ignoreUnknownSignals: true
        target: since_loader.item

        onApproved: {
            since_button.text = (day < 10 ? "0" + day: day) + " ";
            var buffDate = new Date();
            buffDate.setMonth(month - 1)
            var monthNic = Qt.formatDate(buffDate, "MMM")
            monthNic = monthNic.slice(0,3)
            since_button.text += monthNic + " " + year;

            since_loader.source = "";
            Vars.mind = day; Vars.minm = month; Vars.miny = year;
            since_button.day = day;
            since_button.month = month;
            since_button.year = year;
            since_ma.enabled = true
            until_ma.enabled = true

            var firstDate = new Date(since_button.year, since_button.month, since_button.day)
            var secondDate = new Date(until_button.year, until_button.month, until_button.day)

            if(secondDate < firstDate){
                until_button.year = year;
                until_button.month = month
                until_button.day = day

                until_button.text = (day < 10 ? "0" + day: day) + " ";
                buffDate.setMonth(month - 1)
                monthNic = Qt.formatDate(buffDate, "MMM")
                monthNic = monthNic.slice(0,3)
                until_button.text += monthNic + " " + year;
            }

            getData()
        }

        onCanceled: {
            since_loader.source = ""
            since_ma.enabled = true
            until_ma.enabled = true
        }

    }

    Loader{
        z: 2
        id: until_loader
        anchors.fill: container
    }

    Connections{
        ignoreUnknownSignals: true
        target: until_loader.item
        onApproved: {
            until_button.text = (day < 10 ? "0" + day: day) + " ";
            var buffDate = new Date();
            buffDate.setMonth(month - 1)
            var monthNic = Qt.formatDate(buffDate, "MMM")
            monthNic = monthNic.slice(0,3)
            until_button.text += monthNic + " " + year;

            until_loader.source = ""
            until_button.day = day;
            until_button.month = month;
            until_button.year = year;
            since_ma.enabled = true
            until_ma.enabled = true

            getData();
        }
        onCanceled: {
            until_loader.source = ""
            since_ma.enabled = true
            until_ma.enabled = true
        }
    }

    Rectangle{
        width: container.width - 2
        anchors.horizontalCenter: container.horizontalCenter
        height: 100
        color: Vars.bgcolor
        z: 1

        MouseArea{ //choosing since
            id: since_ma
            z: 0
            height: 80
            width: parent.width*0.46
            anchors{
                top: parent.top
                topMargin: 10
                left: parent.left
                leftMargin: parent.width*0.02
            }

            onClicked: {
                Vars.sel_type = 0;
                Vars.curd = since_button.day;
                Vars.curm = since_button.month;
                Vars.cury = since_button.year;

                since_loader.source = "DateSelector.qml";
                enabled = false
                until_ma.enabled = false
            }

            Rectangle{
                anchors.fill: parent
                color: "#efefef"
                border.color: Vars.bdcolor
                border.width: 2
                radius: 20//height/4
                Text{
                    property string day: Vars.curd
                    property string month: Vars.curm
                    property string year: Vars.cury

                    id: since_button
                    text: "с"
                    width: parent.width - 10
                    height: parent.height
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: parent.height/2
                    minimumPixelSize: 40
                    fontSizeMode: Text.Fit
                }
            }
        }

        MouseArea{ //chosing for
            id: until_ma
            z: 0
            anchors{
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: parent.width*0.02
            }
            height: 80
            width: parent.width*0.46

            onClicked: {
                Vars.sel_type = 1;
                Vars.curd = until_button.day;
                Vars.curm = until_button.month;
                Vars.cury = until_button.year;
                until_loader.source = "DateSelector.qml";

                enabled = false;
                since_ma.enabled = false
            }

            Rectangle{
                anchors.fill: parent
                color: "#efefef"
                border.color: Vars.bdcolor
                border.width: 2
                radius: 20//height/4
                Text{
                    property string day: Vars.mind
                    property string month: Vars.minm
                    property string year: Vars.miny

                    id: until_button
                    text: "по"
                    width: parent.width - 10
                    height: parent.height
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: parent.height/2
                    minimumPixelSize: 40
                    fontSizeMode: Text.Fit
                }
            }
        }
    }


    Component.onCompleted: {
        console.log("Component.onCompleted -- StatItem: " + container)
    }
    Component.onDestruction: {
        console.log("Component.onDestruction -- StatItem: " + container)
    }
}
