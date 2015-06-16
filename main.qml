import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import "Variables.js" as Vars

import DB 1.0

ApplicationWindow {
    id: app
    title: qsTr("DA_App")
    width: 560
    height: 800
    visible: true

    color: "#efefef"

    MainMenu{
        Component.onCompleted: {
            addButton("Добавить", "Составить новую смету", "images/add_b.png",  Qt.resolvedUrl("AddMenu.qml"));
            addButton("Просмотр", "Обзор составленных смет", "images/view_b.png", Qt.resolvedUrl("ViewItem.qml"));
            addButton("Статистика", "Статистика за период", "images/stat_b.png", Qt.resolvedUrl("StatItem.qml"));
            addButton("Выход", "", "images/exit_b.png", "");

            var str = data_b.getMinimumDate();
            Vars.curd = str.slice(8, 10);
            Vars.curm = str.slice(5, 7);
            Vars.cury = str.slice(0, 4);

            str = data_b.getMaximumDate();
            Vars.maxy = str.slice(0, 4);

            var date = new Date;
            Vars.mind = date.getDate()
            Vars.minm = date.getMonth() + 1
            Vars.miny = date.getFullYear()
        }
    }

    DataBase{
        id: data_b
    }
}
