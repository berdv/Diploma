import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2
import "Variables.js" as Vars

Rectangle{
    property string scolor: "#e3e3e3"
    property int position: 0
    signal nextScreenCall;
    signal nextScreenAck;
    property bool added_f: false
    property int cm_ind: 0
    signal takeData;

    color: scolor
    height: flck.contentHeight//pheight
    width: flck.contentWidth/flck.scramount//pwidth
    anchors.left: parent.left
    anchors.leftMargin: width*position

    onTakeData: {getItems()}

    function addItem(label, type)
    {
        elementsModel.append({"label":label, "type":type})
        var ind = elementsModel.count - 1;
        if(type == "CheckBox") elementsModel.setProperty(ind, "value", "false");
        if(type == "TextInput") elementsModel.setProperty(ind, "value", "");
        if(type == "NumInput") elementsModel.setProperty(ind, "value", "1");
    }

    function addItem_e(label, type, def) //for extended checkbox
    {
        elementsModel.append({"label":label, "type":type, "def":def})
        var ind = elementsModel.count - 1;
        elementsModel.setProperty(ind, "value", "false");
        elementsModel.setProperty(ind, "ext", def.toString());
        elementsModel.setProperty(ind, "comment", "");
    }

    function addItem_n(label, type, numtype){ //for numinput checkbox
        elementsModel.append({"label":label, "type":type, "numtype": numtype})
        var ind = elementsModel.count - 1;
        elementsModel.setProperty(ind, "value", "1");
    }

    function addItem_l(label, type, cblist){ //for combobox checkbox
        elementsModel.append({"label":label, "type":type, "cblist": cblist})
        var ind = elementsModel.count - 1;
        elementsModel.setProperty(ind, "cb_ind", 0);
        elementsModel.setProperty(ind, "value", "");
    }

    function addItem_t(label, type, texttype){ //for textinput
        elementsModel.append({"label":label, "type":type, "texttype": texttype})
        var ind = elementsModel.count - 1;
        elementsModel.setProperty(ind, "value", "");
    }

    function getItems(){
        var i;
        if(!added_f){
            for(i=0; i< elementsModel.count - 1; i++){
                addCommonItem(position,
                              elementsModel.get(i).label,
                              elementsModel.get(i).type,
                              elementsModel.get(i).value,
                              elementsModel.get(i).cb_ind,
                              elementsModel.get(i).ext,
                              elementsModel.get(i).comment)
                if(i == 0)
                    cm_ind = commonModel.count - 1;
            }
            added_f = true
        }
        nextScreenAck();
    }

    MessageDialog{
        id: mdialog
        standardButtons: StandardButton.Ok
        function show(warning) {
            mdialog.text = warning;
            mdialog.open();
        }
    }

    ListView {
        id: elements
        clip: true
        boundsBehavior: Flickable.DragAndOvershootBounds

        model: ListModel {id:elementsModel}
        delegate: OrderSetupDelegate{
            id: delegate
            onCurStepCnahged: { //next button catcher
                //getItems()
                if(!check){
                    nextScreenCall()
                }
                else{
                    mdialog.show("Внимание, при вводе были допущены ошибки или остались незаполненные поля")
                    //there supposed to be emitted the signal to open screen with typos
                }
            }
            onMove: {gotoIndex(index)}

            function gotoIndex(idx) {
                anim.running = false
                var pos = elements.contentY;
                var destPos;
                elements.positionViewAtIndex(idx, ListView.Beginning);
                destPos = elements.contentY + delegate.com_h - 20;
                anim.from = pos;
                anim.to = destPos;
                anim.running = true;
            }
        }

        width: parent.width
        height: parent.height
        anchors.fill: parent

        NumberAnimation { id: anim; target: elements; property: "contentY"; duration: 300 }

        ScrollBar{ anchors.fill: parent; scrollArea: elements}
    }


}

