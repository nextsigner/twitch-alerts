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
    property string url: 'https://dashboard.twitch.tv/u/ricardo__martin/stream-manager'

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
    Timer{
        id:tCheck
        running: true
        repeat: true
        interval: 1000
        onTriggered: {
            modWhatsapp.webEngineView.runJavaScript('document.getElementsByClassName(\'activity-base-list-item tw-pd-x-2\').length', function(result) {
                //console.log('R1: '+result)
                if(result>=1){
                    //uHtmlEvents
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


                                let msg='Usuario de evento: '+user+' te '+accion
                                console.log(msg)
                                unik.speak(msg)
                            }
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
        unik.debugLog = true
    }
    function onDLR(download) {
        appSettings.dlvVisible=true
        modDlv.append(download);
        download.accept();
    }
}

/*
    <div class="activity-base-list-item tw-pd-x-2"><div class="tw-border-b tw-flex tw-flex-column tw-pd-y-1 tw-relative"><div class="tw-align-items-start tw-flex"><div class="activity-base-list-item__icon tw-c-text-alt-2 tw-flex tw-flex-grow-0 tw-mg-r-1"><figure class="tw-svg"><svg class="tw-svg__asset tw-svg__asset--heart tw-svg__asset--inherit" width="20px" height="20px" version="1.1" viewBox="0 0 20 20" x="0px" y="0px"><g><path fill-rule="evenodd" d="M9.171 4.171A4 4 0 006.343 3H6a4 4 0 00-4 4v.343a4 4 0 001.172 2.829L10 17l6.828-6.828A4 4 0 0018 7.343V7a4 4 0 00-4-4h-.343a4 4 0 00-2.829 1.172L10 5l-.829-.829z" clip-rule="evenodd"></path></g></svg></figure></div><div class="activity-base-list-item__title tw-flex-grow-1"><p class="tw-font-size-5 tw-line-height-heading tw-semibold tw-title tw-title--inherit">neurofisiologa</p></div><div class="tw-flex tw-flex-grow-0"><div data-toggle-balloon-id="007ef3ed-f8d5-4ffb-844e-021a188dfbd7" class="tw-relative"><div data-test-selector="toggle-balloon-wrapper__mouse-enter-detector" style="display: inherit;"><button class="tw-align-items-center tw-align-middle tw-border-bottom-left-radius-small tw-border-bottom-right-radius-small tw-border-top-left-radius-small tw-border-top-right-radius-small tw-button-icon tw-button-icon--small tw-core-button tw-core-button--small tw-inline-flex tw-interactive tw-justify-content-center tw-overflow-hidden tw-relative" aria-haspopup="menu" aria-expanded="false" aria-label="Activar/Desactivar menú de acciones del usuario"><span class="tw-button-icon__icon"><div style="width: 1.6rem; height: 1.6rem;"><div class="ScIconLayout-sc-1bgeryd-0 kbOjdP tw-icon"><div class="ScAspectRatio-sc-1sw3lwy-1 dNNaBC tw-aspect"><div class="ScAspectSpacer-sc-1sw3lwy-0 gkBhyN"></div><svg width="100%" height="100%" version="1.1" viewBox="0 0 20 20" x="0px" y="0px" class="ScIconSVG-sc-1bgeryd-1 cMQeyU"><g><path d="M10 18a2 2 0 110-4 2 2 0 010 4zM10 12a2 2 0 110-4 2 2 0 010 4zM8 4a2 2 0 104 0 2 2 0 00-4 0z"></path></g></svg></div></div></div></span></button></div><div data-test-selector="balloon-inside-click-detector"><div class="tw-absolute tw-balloon tw-balloon--down tw-balloon--right tw-balloon--sm tw-hide" role="dialog"><div class="tw-border-radius-large tw-c-background-base tw-c-text-inherit tw-elevation-3"><div class="tw-flex tw-flex-column"><div class="tw-overflow-auto tw-pd-1"><div class="tw-full-width tw-relative"><button class="tw-block tw-border-radius-medium tw-full-width tw-interactable tw-interactable--default tw-interactable--hover-enabled tw-interactive" aria-label="Seguir"><div class="tw-align-items-center tw-flex tw-pd-05 tw-relative"><div class="tw-align-items-center tw-flex tw-flex-shrink-0 tw-pd-r-05"><div class="tw-align-items-center tw-drop-down-menu-item-figure tw-flex"><div class="ScIconLayout-sc-1bgeryd-0 cFCmuf tw-icon"><div class="ScAspectRatio-sc-1sw3lwy-1 dNNaBC tw-aspect"><div class="ScAspectSpacer-sc-1sw3lwy-0 gkBhyN"></div><svg width="100%" height="100%" version="1.1" viewBox="0 0 20 20" x="0px" y="0px" class="ScIconSVG-sc-1bgeryd-1 cMQeyU"><g><path fill-rule="evenodd" d="M9.171 4.171A4 4 0 006.343 3H6a4 4 0 00-4 4v.343a4 4 0 001.172 2.829L10 17l6.828-6.828A4 4 0 0018 7.343V7a4 4 0 00-4-4h-.343a4 4 0 00-2.829 1.172L10 5l-.829-.829z" clip-rule="evenodd"></path></g></svg></div></div></div></div><div class="tw-flex-grow-1">Seguir</div></div></button></div><div class="tw-full-width tw-relative"><button class="tw-block tw-border-radius-medium tw-full-width tw-interactable tw-interactable--default tw-interactable--hover-enabled tw-interactive" aria-label="Informar"><div class="tw-align-items-center tw-flex tw-pd-05 tw-relative"><div class="tw-align-items-center tw-flex tw-flex-shrink-0 tw-pd-r-05"><div class="tw-align-items-center tw-drop-down-menu-item-figure tw-flex"><div class="ScIconLayout-sc-1bgeryd-0 cFCmuf tw-icon"><div class="ScAspectRatio-sc-1sw3lwy-1 dNNaBC tw-aspect"><div class="ScAspectSpacer-sc-1sw3lwy-0 gkBhyN"></div><svg width="100%" height="100%" version="1.1" viewBox="0 0 20 20" x="0px" y="0px" class="ScIconSVG-sc-1bgeryd-1 cMQeyU"><g><path d="M9 6h2v3H9V6zM9 11a1 1 0 112 0 1 1 0 01-2 0z"></path><path fill-rule="evenodd" d="M7 15l3 3 3-3h2a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2h2zm3 .172L7.828 13H5V5h10v8h-2.828L10 15.172z" clip-rule="evenodd"></path></g></svg></div></div></div></div><div class="tw-flex-grow-1">Informar</div></div></button></div></div></div></div></div></div></div></div></div><div class="activity-base-list-item__subtitle tw-pd-l-3"><span class="">Te <span class="tw-strong">sigue</span></span><span class="">&nbsp;•&nbsp;</span><span class="tw-c-text-alt-2 tw-font-size-6" title="14 ago. 2020">ayer</span></div><div class="activity-base-list-item__extra tw-mg-t-05 tw-pd-l-3"><span class="tw-c-text-alt-2 tw-ellipsis tw-font-size-7 tw-line-clamp-2 tw-word-break-word"></span></div></div></div>
*/
