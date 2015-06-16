import QtQuick 2.0
import "Variables.js" as Vars

Rectangle {
    id: container
    width: viewarea.width//parent.width
    height: mainarea.height

    color: "#efefef"

    Rectangle{color: "#e3e3e3"; height: 1; width: parent.width; anchors.top: parent.top}
    Rectangle{color: "#e3e3e3"; height: 1; width: parent.width; anchors.bottom: parent.bottom}

    MouseArea{
        id: main_ma
        anchors.fill: container

        onClicked: {
            var Data = [], i;
            if(type == 0){
                Data = data_b.getDrillBills(id_options);
                certainModel.clear();
                for(i=0; i<Data.length; i+=6){
                    certainModel.append({
                                            "id_bill": Data[i],
                                            "diameter": Data[i+1],
                                            "depth": Data[i+2],
                                            "group": Data[i+3],
                                            "amount": Data[i+4],
                                            "price": Data[i+5]
                                        });
                }

                billLoader.source = "ViewBill.qml"
                billLoader.item.type = 0
                Vars.cur_v_ind = index
            }
            else{
                Data = data_b.getSawBills(id_options);
                certainModel.clear();
                for(i=0; i<Data.length; i+=11){
                    certainModel.append({
                                            "id_bill": Data[i],
                                            "depth": Data[i+1],
                                            "length": Data[i+2],
                                            "area": Data[i+3],
                                            "amount": Data[i+4],
                                            "twosided": Data[i+5],
                                            "id_tool": Data[i+6],
                                            "group": Data[i+7],
                                            "ratio": Data[i+8],
                                            "comment": Data[i+9],
                                            "price": Data[i+10]
                                        });
                }

                billLoader.source = "ViewBill.qml"
                billLoader.item.type = 1
                Vars.cur_v_ind = index
            }
        }
    }

    Image {
        id: img
        source: (type == 1) ? "images/saw_ico.png" : "images/drill_ico.png"
        anchors{
            left: parent.left
            leftMargin: 5
            verticalCenter: parent.verticalCenter
        }
        height: 80
        width: 80
    }

    Rectangle{
        id: mainarea
        color: "transparent"
        width: container.width - 20 - img.width
        height: main_inf.height
        anchors{
            left: img.right
            leftMargin: 10
            verticalCenter: container.verticalCenter
        }

        Rectangle{
            id: main_inf
            height: price_inf.height + cons_inf.height + sal_inf.height
            width: parent.width*0.7
            color: "transparent"

            Rectangle{color: Vars.bdcolor; anchors.left: parent.left; width: 1; height: parent.height}
            Rectangle{color: Vars.bdcolor; anchors.top: cons_inf.top; width: parent.width; height: 1}
            Rectangle{color: Vars.bdcolor; anchors.top: sal_inf.top; width: parent.width; height: 1}


            Rectangle{
                id: price_inf
                width: parent.width - 10
                height: price_t.contentHeight + 10
                color: "transparent"
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 10
                Text{
                    id: price_t
                    width: parent.width
                    font.pixelSize: 40
                    wrapMode: Text.WordWrap
                    text: "<b>Стоимость:</b> " + price + "р"
                }
            }

            Rectangle{
                id: cons_inf
                width: parent.width - 10
                height: cons_t.contentHeight + 10
                color: "transparent"
                anchors.top: price_inf.bottom
                anchors.left: parent.left
                anchors.leftMargin: 10
                Text{
                    id: cons_t
                    width: parent.width
                    font.pixelSize: 40
                    wrapMode: Text.WordWrap
                    text: "<b>Расходные метериалы:</b> " + consumables + "р"
                }
            }

            Rectangle{
                id: sal_inf
                width: parent.width - 10
                height: sal_t.contentHeight + 10
                color: "transparent"
                anchors.top: cons_inf.bottom
                anchors.left: parent.left
                anchors.leftMargin: 10
                Text{
                    id: sal_t
                    width: parent.width
                    font.pixelSize: 40
                    wrapMode: Text.WordWrap
                    text: "<b>Оплата труда:</b> " + salary + "р"
                }
            }
        }

        Rectangle{ //date + count
            id: extra_inf
            anchors.right: parent.right
            height: main_inf.height
            width: parent.width*0.3
            color: "transparent"

            Rectangle{color: Vars.bdcolor; anchors.left: parent.left; width: 1; height: parent.height}
            Rectangle{color: Vars.bdcolor; anchors.verticalCenter: parent.verticalCenter; width: parent.width; height: 1}

            Rectangle{
                id: date_fld
                width: parent.width;
                height: parent.height/2
                color: "transparent"
                anchors.bottom: parent.bottom

                Text{
                    id: date_t
                    font.pixelSize: 40
                    anchors.fill: parent
                    text: date.slice(8,10) + "." + date.slice(5,7) + "." + date.slice(2,4)
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                }
            }

            Rectangle{
                id: count_fld
                width: parent.width;
                height: parent.height/2
                color: "transparent"
                anchors.top: parent.top

                Text{
                    id: count_t
                    font.pixelSize: 50
                    anchors.fill: parent
                    text: count
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                }
            }
        }
    }
}

