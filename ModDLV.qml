import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.0
import QtWebEngine 1.4
import QtQuick.Layouts 1.3

Rectangle {
    id: downloadView
    color: "white"

    ListModel {
        id: downloadModel
        property var downloads: []
    }

    function append(download) {
        downloadModel.append(download);
        downloadModel.downloads.push(download);
    }

    Component {
        id: downloadItemDelegate

        Rectangle {
            width: listView.width
            height: app.fs
            anchors.margins: 10
            radius: 3
            color: "transparent"
            border.color: "black"
            Rectangle {
                id: progressBar

                property real progress: downloadModel.downloads[index]
                                       ? downloadModel.downloads[index].receivedBytes / downloadModel.downloads[index].totalBytes : 0

                radius: 3
                color: width == listView.width ? "green" : "#2b74c7"
                width: listView.width * progress
                height: cancelButton.height

                Behavior on width {
                    SmoothedAnimation { duration: 100 }
                }
            }
            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 20
                }
                Label {
                    id: label
                    text: '<b>'+path+'</b>'
                    color: "red"
                    anchors {
                        verticalCenter: cancelButton.verticalCenter
                        left: parent.left
                        right: cancelButton.left
                    }
                }
                Button {
                    id: cancelButton
                    anchors.right: parent.right
                    text:""
                    Text{
                        text: "\uf2d3"
                        font.family: "FontAwesome"
                        font.pixelSize: app.fs*0.5
                        anchors.centerIn: parent
                    }

                    onClicked: {
                        var download = downloadModel.downloads[index];

                        download.cancel();

                        downloadModel.downloads = downloadModel.downloads.filter(function (el) {
                            return el.id !== download.id;
                        });
                        downloadModel.remove(index);
                    }
                }
            }
        }

    }
    ListView {
        id: listView
        anchors {
            topMargin: 10
            top: downloadView.top
            bottom: downloadView.bottom
            horizontalCenter: downloadView.horizontalCenter
        }
        width: downloadView.width - 20
        spacing: 5

        model: downloadModel
        delegate: downloadItemDelegate

        Text {
            visible: !listView.count
            horizontalAlignment: Text.AlignHCenter
            height: 30
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            font.pixelSize: 20
            text: "No hay descargas activas"
        }
    }
}
