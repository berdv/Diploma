import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.3
import "Variables.js" as Vars

Item{

    property Item pageItem

    id: root
    anchors.fill: parent;

    //#################################### key_back processing ################################

    MessageDialog{
        id: back_dialog
        standardButtons: StandardButton.Yes | StandardButton.No
        function show(warning) {
            back_dialog.text = warning;
            back_dialog.open();
        }

        onYes: {
            loader.source = "OrderSummary.qml";
            loader.item.loader = loader;
            loader.item.from = Vars.cur_type;
        }

    }

    MessageDialog{
        id: quit_dialog
        standardButtons: StandardButton.Yes | StandardButton.No
        function show(warning) {
            quit_dialog.text = warning;
            quit_dialog.open();
        }

        onYes: {
            pageItem.nextPage = "";
            Vars.started_f = false;
            Vars.cur_scr = 0;
        }
    }

    //###########################################################################

    //##########################Key_back processing##############################
    Keys.onReleased: {
        if (event.key == Qt.Key_Back){//(event.key == Qt.Key_Escape){
            event.accepted = false
            if(Vars.started_f && loader.source != "qrc:/OrderSummary.qml"){
                if(loader.source != "qrc:/OrderPublishing.qml"){
                    if(Vars.added_f)
                        back_dialog.show("Ввод не завершен. Хотите вернуться к предыдущему меню?");
                    else
                        quit_dialog.show("Хотите вернуться в главное меню? Все несохраненные данные будут удалены")
                }
                else{
                    loader.source = "OrderSummary.qml";
                    loader.item.loader = loader;
                    loader.item.from = Vars.cur_type;
                }

            }
            else{
//                if(!Vars.started_f){
//                    pageItem.nextPage = "";
//                    Vars.cur_scr = 0;
//                }
//                else
                    quit_dialog.show("Хотите вернуться в главное меню? Все несохраненные данные будут удалены")
            }
        }
    }

    //##########################################################################################

    //#################################Loader properties########################################

    MessageDialog{
        id: mdialog
        standardButtons: StandardButton.Ok// | StandardButton.No
        function show(warning) {
            mdialog.text = warning;
            mdialog.open();
        }
        onYes: { Qt.quit() }
    }

    function processOrder(type){
        if(!type){
            console.log("current drill order has just completed")
        }
        else{
            console.log("current saw order has just completed")
        }
        Vars.added_f = true; //signal that there's something added to not go to next screen by key_back
        addOrderModel(commonModel);
        commonModel.clear();
        loader.source = "OrderSummary.qml";
        loader.item.loader = loader;
        loader.item.from = type
    }

    Loader{
        id: loader
        property bool choosed: false // show element only when something is choosed
        focus: true
        visible: choosed
        //anchors.fill: parent
        width: parent.width
        height: parent.height;

        onLoaded: { item.menuItem = pageItem  }
        onSourceChanged: {Vars.cur_scr = 0;}
    }

    Connections{
        ignoreUnknownSignals: true
        target: loader.item
        onOrderComplete: {processOrder(from)}
    }

    //##########################################################################################

    //################################Global Model for data#####################################

    ListModel {id: orderModel}
    ListModel {id: commonModel}

    function addCommonItem(scr, label, type, value, cb_ind, ext, comment)
    {
        commonModel.append({"scr": scr, "label":label, "type":type, "value":value, "cb_ind": cb_ind, "ext": ext, "comment": comment})
    }

    function addOrderModel(cm){
        orderModel.append({element: []});
        var num;
        for(var i= 0; i< cm.count; i++){
            orderModel.get(orderModel.count - 1).element.append({
                                                                    "scr": cm.get(i).scr,
                                                                    "label": cm.get(i).label,
                                                                    "type": cm.get(i).type,
                                                                    "value": cm.get(i).value,
                                                                    "cb_ind": cm.get(i).cb_ind,
                                                                    "ext": cm.get(i).ext,
                                                                    "comment": cm.get(i).comment
                                                                });
        }
    }

    //##########################################################################################

    //######################################Page view###########################################

    Rectangle {
        color: "#e3e3e3"
        id: menu
        anchors.fill: parent
        visible: !loader.choosed

        AddMenuButton{
            position: 0
            pic: "images/drill_b_wb2.png"
            name: "Бурение"
            onButtonClicked: {
                loader.source = "DrillSetup.qml"
                loader.choosed = true
                menu.visible = false
                Vars.started_f = true
                Vars.cur_type = 0;
            }
        }
        AddMenuButton{
            position: 1
            name: "Резка"
            pic: "images/saw_b_wb2.png"
            onButtonClicked: {
                loader.source = "SawSetup.qml"
                loader.choosed = true
                menu.visible = false
                Vars.started_f = true
                Vars.cur_type = 1;
            }
        }
    }
    Component.onCompleted: {
        console.log("Component.onCompleted -- AddMenu: " + root)
    }
    Component.onDestruction: {
        console.log("Component.onDestruction -- AddMenu: " + root)
    }
}
