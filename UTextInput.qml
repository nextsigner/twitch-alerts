import QtQuick 2.0

Item{
    id:r
    width: parent.width
    height: app.fs*2
    property alias text:tiData.text
    property string dataType: 'text'
    property alias maximumLength: tiData.maximumLength
    property alias focusTextInput:tiData.focus
    property alias customCursor: rectCursor
    property string label: 'Input: '
    property color fontColor: app.c2
    property int customHeight: -1
    property RegExpValidator regularExp
    signal seted(string text)
    onFocusChanged: {
        if(focus){
            tiData.focus=true
        }
    }
    Row{
        spacing: app.fs*0.5
        Text{
            id: label
            text: r.label
            font.family: unikSettings.fontFamily
            font.pixelSize: app.fs
            color: r.fontColor
            anchors.verticalCenter: parent.verticalCenter
        }
        Rectangle{
            width: r.width-label.contentWidth-parent.spacing
            height: r.customHeight===-1?app.fs*2:r.customHeight
            color: 'transparent'
            border.width: unikSettings.borderWidth
            border.color: r.fontColor
            radius: unikSettings.radius
            Rectangle{
                anchors.fill: parent
                color: !tiData.focus?app.c2:'transparent'
                opacity: !tiData.focus?0.25:1.0
                radius: parent.radius
                border.width: !tiData.focus?unikSettings.borderWidth:unikSettings.borderWidth+1
                border.color: r.fontColor
            }
            TextInput{
                id: tiData
                font.pixelSize: app.fs
                //focus: true
                width: parent.width-app.fs
                height: app.fs
                clip: true
                anchors.centerIn: parent
                onTextChanged: r.textChanged(text)
                Keys.onReturnPressed: r.seted(text)
                color: r.fontColor
                validator: r.regularExp
                cursorDelegate: rectCursor
            }
        }
    }
    RegExpValidator{
        id: regExpDataType
    }
    Component{
        id: rectCursor
        Rectangle {
            color: app.c2
            width: app.fs*0.25
            Timer{
                running: true
                repeat: true
                interval: 500
                onTriggered: {
                    if(tiData.focus){
                        parent.visible=!parent.visible
                    }else{
                        parent.visible=false
                    }

                }
            }
        }
    }
    Component.onCompleted: {
        if(r.dataType!=='text'){
            if(r.dataType==='dd.dd'){
                regExpDataType.regExp = /^(^([1-9][0-9]{1})[\.]{1}[0-9]{2})|^(^([1-9][0-9]{0})[\.]{1}[0-9]{2})/
                r.regularExp = regExpDataType
            }
        }
    }
}
