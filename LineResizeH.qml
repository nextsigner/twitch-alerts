
        import QtQuick 2.0
       
        Item {
            id: raiz
            width: parent.width
            height: 10
            property int minY: 0
            property int maxY: raiz.parent.height-100
            signal lineReleased
            Rectangle{
                anchors.fill: raiz
                color: '#ccc'
                border.width: 1
                border.color: '#ccc'
                MouseArea{
                    //anchors.fill: parent
                    width: parent.width
                    height: parent.height*1.6
                    anchors.centerIn: parent
                    hoverEnabled: true
                    cursorShape: Qt.SizeVerCursor
                    drag.target: raiz
                    drag.axis: Drag.YAxis
                    drag.minimumY: raiz.minY
                    drag.maximumY: raiz.maxY
                    onEntered: parent.color = 'red'
                    onExited: parent.color = '#ccc'
                    onReleased: {
                        lineReleased()
                    }
                }
            }
        }
     
