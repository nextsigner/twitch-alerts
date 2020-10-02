import QtQuick 2.0

Item {
    id: r
    width: 500
    height: 500
    anchors.centerIn: parent
    property string user: 'nextsigner'
    property string action: 'follow'
    property int fs: 30
    Rectangle{
        anchors.fill: r
        border.width: 3
        border.color: 'red'
        radius: width*0.1
        Row{
            id: rowUser
            spacing: r.fs
            anchors.centerIn: parent
            SequentialAnimation{
                running: true
                loops: Animation.Infinite
                NumberAnimation{
                    target: rowUser
                    property: "spacing"
                    from: r.fs
                    to: r.fs*2
                    duration: 500
                }
                NumberAnimation{
                    target: rowUser
                    property: "spacing"
                    from: r.fs*2
                    to: r.fs
                    duration: 250
                }
            }
            Repeater{
                model: r.user.length
                Item{
                    width: r.fs*1.5
                    height: width
                    Text{
                        text: 'A'//r.user.at(index)
                        font.pixelSize: r.fs
                        anchors.centerIn: parent
                        color: 'red'
                    }
                }
            }
        }
    }
}
