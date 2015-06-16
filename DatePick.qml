import QtQuick 2.1
import QtQuick.Controls 1.1
import "Variables.js" as Vars


Item {
    signal dateSelected();
    signal checkDate();

    id: container

    property int day: Vars.curd
    property int month: Vars.curm
    property int year: Vars.cury

    property int minday
    property int minmonth
    property int minyear

    anchors.fill: parent

    onDateSelected: {
        var days, i;
        daymodel.remove(29, daymodel.count - 29);
        if(month == 2){
            if(!((year - 2000)%4))
                daymodel.append({ value: 29, text: "29" })
        }
        else{
            if((month <= 7 && month%2) || (month >7 && month%2 == 0))
                days = 3;
            else
                days = 2

            for(i=0; i<days; i++)
                daymodel.append({ value: 29+i, text: (29+i).toString() })
        }
        daymodel.append({ value: -1, text: "" })

        var maxday = daymodel.get(daymodel.count - 2).value;
        var newday = (day <= maxday) ? day : maxday
        dayPicker.setValue(newday)
        day = newday;
    }

    onCheckDate: {
        var minDate = new Date(minyear, minmonth, minday)
        var curDate = new Date(year, month, day);
        if(curDate < minDate){
            year = minyear; month = minmonth; day = minday;
            dayPicker.setValue(minday);
            monthPicker.setValue(minmonth);
            yearPicker.setValue(minyear%100);
        }
    }


    Rectangle{
        id: work_area
        width: container.width - 20
        height: container.height - 20 - 100
        anchors.top: container.top
        anchors.topMargin: 10
        anchors.horizontalCenter: container.horizontalCenter
        color: "transparent"
        border.color: Vars.bdcolor
        border.width: 3
        radius: 20


        ACPicker { //day
            id: dayPicker
            wdth: work_area.width*0.3 - 20

            model:
                ListModel {
                id: daymodel
                Component.onCompleted: {
                    append({ value: -1, text: " " })
                    for(var i = 1; i <= 31; i++){
                        var norm = i.toString();
                        if( i < 10 ) norm = "0" + i
                        append({ value: i, text: norm })
                    }
                    append({ value: -1, text: " " })
                }
            }

            Component.onCompleted: {
                setValue(day)
                dateSelected()
            }

            onIndexSelected: {
                day = value
                checkDate();
            }

            anchors {
                left: work_area.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
        }

        ACPicker {
            id: monthPicker
            wdth: work_area.width*0.3 - 20

            model:
                ListModel {
                id: monthmodel
                Component.onCompleted: {
                    var buffDate = new Date();
                    append({ value: -1, text: " " })
                    for(var i = 1; i <= 12; i++){
                        buffDate.setMonth(i - 1)
                        var monthNic = Qt.formatDate(buffDate, "MMM")
                        monthNic = monthNic.slice(0,3)
                        append({ value: i, text: monthNic })
                    }
                    append({ value: -1, text: " " })
                }
            }
            anchors.centerIn: parent

            Component.onCompleted: {
                setValue(month)
            }

            onIndexSelected: {
                month = value// - 1
                dateSelected()
                checkDate();

            }

            anchors {
                horizontalCenter: work_area.horizontalCenter
                horizontalCenterOffset: dayPicker.wdth/2 - yearPicker.wdth/2
                verticalCenter: work_area.verticalCenter
            }
        }

        ACPicker {
            id: yearPicker
            wdth: work_area.width*0.4 - 20

            model:
                ListModel {
                id: yearmodel
                Component.onCompleted: {
                    append({ value: -1, text: " " })
                    for(var i = 2001; i <= Vars.maxy; i++){
                        append({ value: i - 2000, text: i.toString() })
                    }
                    append({ value: -1, text: " " })
                }
            }

            Component.onCompleted: {
                setValue(year%100)
            }

            onIndexSelected: {
                year = value + 2000
                dateSelected()
                checkDate();
            }

            anchors {
                right: work_area.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {
            id: selector

            width: container.width*0.96
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: container.height/4
            color: "#304fb9ff"
        }

    }

    Rectangle{
        id: cancel_b
        anchors.bottom: container.bottom
        anchors.bottomMargin: 10
        anchors.left: container.left
        anchors.leftMargin: container.width*0.02
        width: container.width*0.46
        height: 80
        radius: 20//height/4
        border.color: Vars.bdcolor

        gradient: Gradient{
            GradientStop { position: 0 ; color: cancel_ma.pressed ? "#ddd" : "#eee"
                Behavior on color { ColorAnimation{ duration: 150 } }
            }
            GradientStop { position: 1 ; color: cancel_ma.pressed ? "#eee" : "#ddd"
                Behavior on color { ColorAnimation{ duration: 150 } }
            }
        }

        MouseArea{
            id: cancel_ma
            anchors.fill: parent
            onClicked: deny();
        }

        Text {
            id: cancel_lbl
            text: "Отмена"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: parent.height/2.9
            minimumPixelSize: 30
            fontSizeMode: Text.Fit
        }

    }

    Rectangle{
        id: ok_b
        anchors.bottom: container.bottom
        anchors.bottomMargin: 10
        anchors.right: container.right
        anchors.rightMargin: container.width*0.02
        width: container.width*0.46
        height: 80
        radius: 20//height/4
        border.color: Vars.bdcolor

        gradient: Gradient{
            GradientStop { position: 0 ; color: ok_ma.pressed ? "#ddd" : "#eee"
                Behavior on color { ColorAnimation{ duration: 150 } }
            }
            GradientStop { position: 1 ; color: ok_ma.pressed ? "#eee" : "#ddd"
                Behavior on color { ColorAnimation{ duration: 150 } }
            }
        }

        MouseArea{
            id: ok_ma;
            anchors.fill: parent
            onClicked: { confirm(); }
        }

        Text {
            id: ok_lbl
            text: "Выбрать"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: parent.height/2.9
            minimumPixelSize: 30
            fontSizeMode: Text.Fit
        }
    }


}

