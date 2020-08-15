/*
Jaunary 2018
This file is created by nextsigner
This code is used for the unik qml engine system too created by nextsigner.
Please read the Readme.md from https://github.com/nextsigner/wwas.git
Contact
    email: nextsigner@gmail.com
    whatsapps: +54 11 3802 4370
*/
import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0
import QtWebEngine 1.4
ApplicationWindow {
    id:app
    visible: true
    width: 1280
    height: 500
    //x:0
    //y:0
    visibility:"Maximized"
    title: 'Unik Twitch Alerts'
    color: '#333'
    property string moduleName: 'wwas'
    property int fs: app.width*0.02
    property color c1: "#1fbc05"
    property color c2: "#4fec35"
    property color c3: "white"
    property color c4: "black"
    property color c5: "#333333"
    property string tool: ""

    property int uAudioIndex: 0
    property int statePlaying: 0
    property string url: 'https://dashboard.twitch.tv/popout/u/ricardo__martin/stream-manager/activity-feed'//'https://dashboard.twitch.tv/u/ricardo__martin/stream-manager'

    property string colorBarra:'white'

    property var audioDurs: []
    property var audioDursPlayed: []
    property real uDurPlaying

    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    USettings{
        id: unikSettings
        url: app.moduleName
        Component.onCompleted: {
            currentNumColor=0
            let mc0=defaultColors.split('|')
            let mc1=mc0[currentNumColor].split('-')
            app.c1=mc1[0]
            app.c2=mc1[1]
            app.c3=mc1[2]
            app.c4=mc1[3]
        }
    }
    Row{
        anchors.fill: parent
        Rectangle{
            id: xTools
            width: app.width*0.02
            height: app.height
            color: "#fff"
            z:container.z+99999
            Rectangle{
                width: 1
                height: parent.height
                color: "black"
                anchors.right: parent.right
            }
            Column{
                id: colTools
                width: parent.width
                spacing:  width*0.5
                anchors.verticalCenter: parent.verticalCenter
                Boton{
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    h: w
                    t: modWhatsapp.url.indexOf(app.url)===0?"\uf167":"\uf0ac"
                    d: modWhatsapp.url==='https://web.whatsapp.com/'?'Ver código fuente de esta app.':'Ir a Whatsapp Web'
                    r:app.fs*0.2
                    onClicking: {
                        modWhatsapp.url=modWhatsapp.url==='https://web.whatsapp.com/'?'https://github.com/nextsigner/wwas':'https://web.whatsapp.com/'
                        //appSettings.red=0;
                    }
                }
                Item{width: parent.width*0.9;height: width}
                Item{width: parent.width*0.9;height: width}
                Boton{
                    id: btnDLV
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: enabled ?1.0:0.5
                    h: w
                    t: "\uf019"
                    d: 'Ver Descargas'
                    r:app.fs*0.2
                    onClicking: {
                        appSettings.dlvVisible = !appSettings.dlvVisible
                    }
                }
                Boton{
                    id: btnUpdate
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: enabled ?1.0:0.5
                    h: w
                    t: "\uf021"
                    d: 'Actualizar esta aplicación'
                    r:app.fs*0.2
                    onClicking: {
                        unik.mkdir(pws+"/wwas")
                        let cmd="-git=https://github.com/nextsigner/wwas.git,-folder="+pws+"/wwas"
                        unik.setUnikStartSettings(cmd)
                        unik.restartApp("")
                    }
                }
                Boton{
                    id: btnApagar
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: enabled ?1.0:0.5
                    h: w
                    t: "\uf011"
                    d: 'Apagar'
                    r:app.fs*0.2
                    onClicking:app.close()
                }
            }
        }
        Rectangle{
            id:container
            width: parent.width
            height: parent.height
            color: '#333'
            ModWebView{
                id:modWhatsapp;
                red:0;
                url: app.url
                //url:'https://web.whatsapp.com/'
                userAgent: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36'
                //userAgent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/73.0.3683.75 Chrome/73.0.3683.75 Safari/537.36"
            }
            LineResizeH{
                id:lineRH;
                y:visible?appSettings.pyLineRH1: parent.height;
                //onLineReleased: appSettings.pyLineRH1 = y;
                visible: modDlv.visible;
                onYChanged: {
                    if(y<container.height/3){
                        y=container.height/3+2
                    }
                }
                Component.onCompleted: {
                    if(lineRH.y<container.height/3){
                        lineRH.y=container.height/3+2
                    }
                }
            }
            ModDLV{
                id: modDlv
                width: parent.width
                anchors.top: lineRH.bottom;
                anchors.bottom: parent.bottom;
                //zoomFactor: 0.5
                visible: false//appSettings.dlvVisible;
            }
        }
    }
    ULogView{id:uLogView}
    UWarnings{id:uWarnings}
    Timer{
        //id:tCheck
        running: true
        repeat: true
        interval: 6000
        onTriggered: {
            if(!tCheck.running){
                //tCheck.interval=3000
                tCheck.start()
            }
        }
    }
    Timer{
        id:tResetAudioIndexPlaying
        running: false
        repeat: false
        interval: 1000000
        onTriggered: {
            app.statePlaying=0
        }
    }

    property string uHtmlEvents: ''
    property string uMsg: ''
    Timer{
        id:tCheck
        running: true
        repeat: true
        interval: 1000
        onTriggered: {
            modWhatsapp.webEngineView.runJavaScript('document.getElementsByClassName(\'activity-base-list-item tw-pd-x-2\').length', function(result) {
                //console.log('R1: '+result)
                if(result>=1){
                    modWhatsapp.webEngineView.runJavaScript('document.getElementsByClassName(\'activity-base-list-item tw-pd-x-2\')[0].innerHTML', function(result2) {
                        if(result2!==app.uHtmlEvents){
                            //return
                            //}
                            //console.log('R2: '+result2)
                            let m0=result2.split('tw-semibold tw-title tw-title--inherit\">')
                            //console.log('R3 m0.length=: '+m0.length)
                            if(m0.length>=2){
                                //console.log('R4: '+m0[1])
                                let m1=m0[1].split('</p>')
                                //console.log('R5: '+m1[0])
                                let user=m1[0]

                                let m2=result2.split('<span class=\"tw-strong\">')
                                //console.log('R6: '+m2[1])
                                let m3=m2[1].split('</span>')
                                //console.log('R7: '+m3[0])
                                let accion=m3[0]

                                let msgF=''
                                if(accion.indexOf('sigue')>=0){
                                     msgF=' te ha comenzado a seguir.'
                                }else if(accion.indexOf('raid')>=0){
                                    msgF=' te ha hechado un raid.'
                                }else{
                                    msgF=' ha realizado un evento desconocido por este robot pelotudo.'
                                }
                                let msg='Atención: '+user+msgF
                                console.log(msg)
                                if(app.uMsg!==msg){
                                    app.uMsg=msg
                                    unik.speak(msg)
                                }
                            }
                            uHtmlEvents=result2
                        }else if(result2===app.uHtmlEvents){
                            return
                        }else{
                            uHtmlEvents=result2
                        }
                    });
                }
            });
        }
    }
    //    Text {
    //        id: info
    //        font.pixelSize: 30
    //        color: 'red'
    //        width: app.width*0.8
    //        wrapMode: Text.WordWrap
    //        z: modWhatsapp.z+100000
    //    }
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    Component.onCompleted:  {
        //unik.debugLog = true
        if(Qt.platform.os==='linux'){
            let m0=(''+ttsLocales).split(',')
            let index=0
            for(var i=0;i<m0.length;i++){
                console.log('Language: '+m0[i])
                if((''+m0[i]).indexOf('Spanish (Spain)')>=0){
                    index=i
                    break
                }
            }
            unik.ttsLanguageSelected(index)
            //unik.speak('Idioma Español seleccionado.')
        }
    }
    function onDLR(download) {
        appSettings.dlvVisible=true
        modDlv.append(download);
        download.accept();
    }
}
