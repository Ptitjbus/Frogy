import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.2

Item {
    id: syncScreenItem
    width: 1024
    height: 600
    property alias isVisible : syncScreen.visible

    Rectangle {
        id: syncScreen
        color: "blue"
        anchors.fill: parent
        visible: true
        z:1

        Rectangle {
            id: circleBg
            color: "#2E524518"
            width: 350
            height: width
            anchors.centerIn: parent
            radius: width / 2

            SequentialAnimation on width {
                loops: Animation.Infinite
                running: true

                PropertyAnimation {
                    to: 350
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }

                PropertyAnimation {
                    to: 400
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Rectangle {
            id: circle
            color: "#2E5245"
            width: 350
            height: width
            anchors.centerIn: parent
            radius: width / 2
            border.color: "#2E524518"
        }

        Text {
            id: syncingText
            text: "Synchronisation en cours"
            anchors.centerIn: parent
            width: circle.width-100
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "white"
            font.pixelSize: 30
            font.bold: true
        }
    }
}