import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import "Variables.js" as Vars

import DB 1.0

Rectangle {
    id: container
    anchors.fill: parent
    border.color: Vars.bdcolor
    border.width: 2
    color: Vars.bgcolor

    Rectangle{
        id: statarea
        width: parent.width*0.96
        height: parent.height - 110// - 90
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 20
        //anchors.bottom: statb.top
        //anchors.bottomMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 100
        border.color: Vars.bdcolor
        border.width: 2
        color: "#efefef"

        ListView{

            id: stat_v
            cacheBuffer: 2
            orientation: Qt.Horizontal
            width: statarea.width
            height: statarea.height
            boundsBehavior: Flickable.StopAtBounds
            snapMode: ListView.SnapOneItem
            spacing: 20

            interactive: false

            model: ListModel{id: statModel}

            delegate:  Loader{
                source: type == 0 ? "StatDelegate.qml" : "StatInfo.qml"
            }//StatDelegate{id: stat_del; }


            //onCurrentIndexChanged: {
            onContentXChanged: {
                if(contentX > 556)
                    left.visible = true
                else
                    left.visible = false
                if(contentX < 3*container.width)
                    right.visible = true
                else
                    right.visible = false
            }

            Image {
                id: left
                source: "images/arrowprev.png";
                width: 100
                height: 100
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                opacity: 0.3
                visible: false
            }

            Image {
                id: right
                source: "images/arrownext.png";
                width: 100
                height: 100
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                opacity: 0.3
                visible: false
            }
        }
    }

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

        Data = data_b.getStat(d1,d2);

        statModel.clear();

        statModel.append({ "tabs": 3, "label": "Общая статистика",
                "tab_lbl": [], "value": [], "type": 1});

        statModel.get(0).value.append({"val": Data[8]});
        statModel.get(0).value.append({"val": Data[9]});
        statModel.get(0).value.append({"val": Data[10]});
        statModel.get(0).value.append({"val": Data[0] + Data[1]});

        statModel.get(0).tab_lbl.append({"val": "Общая стоимость расходных материалов"});
        statModel.get(0).tab_lbl.append({"val": "Общая стоимость заказов"});
        statModel.get(0).tab_lbl.append({"val": "Общая стоимость зараплаты"});
        statModel.get(0).tab_lbl.append({"val": "Количество заказов"});

        //~~~~~~~~

        statModel.append({ "tabs": 2, "label": "Количество заказов",
                "tab_lbl": [], "value": [], "type": 0});

        statModel.get(1).value.append({"val": Data[0]});
        statModel.get(1).value.append({"val": Data[1]});

        statModel.get(1).tab_lbl.append({"val": "Бурение"});
        statModel.get(1).tab_lbl.append({"val": "Резка"});

        //~~~~~~~~

        statModel.append({ "tabs": 2, "label": "Стоимость расход. мат.",
                "tab_lbl": [], "value": [], "type": 0});

        statModel.get(2).value.append({"val": Data[2]});
        statModel.get(2).value.append({"val": Data[5]});

        statModel.get(2).tab_lbl.append({"val": "Бурение"});
        statModel.get(2).tab_lbl.append({"val": "Резка"});

        //~~~~~~~~

        statModel.append({ "tabs": 2, "label": "Стоимость заказов",
                "tab_lbl": [], "value": [], "type": 0});

        statModel.get(3).value.append({"val": Data[3]});
        statModel.get(3).value.append({"val": Data[6]});

        statModel.get(3).tab_lbl.append({"val": "Бурение"});
        statModel.get(3).tab_lbl.append({"val": "Резка"});

        //~~~~~~~~

        statModel.append({ "tabs": 2, "label": "Зарплата",
                "tab_lbl": [], "value": [], "type": 0});

        statModel.get(4).value.append({"val": Data[4]});
        statModel.get(4).value.append({"val": Data[7]});

        statModel.get(4).tab_lbl.append({"val": "Бурение"});
        statModel.get(4).tab_lbl.append({"val": "Резка"});
    }

    Loader{
        z: 1
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

            getData();
            stat_v.interactive = true;
            if(stat_v.contentX > 556)
                left.visible = true
            else
                left.visible = false
            if(stat_v.contentX < 3*container.width)
                right.visible = true
            else
                right.visible = false
        }

        onCanceled: {
            since_loader.source = ""
            since_ma.enabled = true
            until_ma.enabled = true
        }

    }

    Loader{
        z: 1
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
            stat_v.interactive = true;
            if(stat_v.contentX > 556)
                left.visible = true
            else
                left.visible = false
            if(stat_v.contentX < container.width)
                right.visible = true
            else
                right.visible = false
        }
        onCanceled: {
            until_loader.source = ""
            since_ma.enabled = true
            until_ma.enabled = true
        }
    }

    MouseArea{ //choosing since
        id: since_ma
        z: 0
        height: 80
        width: container.width*0.46
        anchors{
            top: container.top
            topMargin: 10
            left: container.left
            leftMargin: container.width*0.02
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
            top: container.top
            topMargin: 10
            right: container.right
            rightMargin: container.width*0.02
        }
        height: 80
        width: container.width*0.46

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


    Component.onCompleted: {
        console.log("Component.onCompleted -- StatItem: " + container)

        var i;
        for(i=0; i<4; i++){
            statModel.append({
                                 "tabs": 0,
                                 "label": "",
                                 "tab_lbl": [],
                                 "value": [],
                                 "type": 0
                             });
            statModel.get(i).value.append({"val": 0});
            statModel.get(i).tab_lbl.append({"val": ""});
        }
    }
    Component.onDestruction: {
        console.log("Component.onDestruction -- StatItem: " + container)
    }
}
