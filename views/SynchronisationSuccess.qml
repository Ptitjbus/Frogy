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
        color: "#50E28B"
        anchors.fill: parent
        visible: false
        z:2

        Rectangle {
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
                    duration: 300
                    easing.type: Easing.InOutQuad
                }

                PropertyAnimation {
                    to: 400
                    duration: 300
                    easing.type: Easing.InOutQuad
                }

                PropertyAnimation {
                    to: 350
                    duration: 300
                    easing.type: Easing.InOutQuad
                }

                PropertyAnimation {
                    to: 400
                    duration: 300
                    easing.type: Easing.InOutQuad
                }

                PropertyAnimation {
                    to: 350
                    duration: 300
                    easing.type: Easing.InOutQuad
                }

                PropertyAnimation {
                    to: 400
                    duration: 2000
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Rectangle {
            id: circleSuccess
            color: "#2E5245"
            width: 350
            height: width
            anchors.centerIn: parent
            radius: width / 2
            border.color: "#2E524518"
        }

        Image {
            source: "../assets/icons/check.svg"
            width: 112
            height: 84
            anchors.centerIn: parent
        }

        Text {
            id: waitingText
            text: "Succès ! Frogy est synchronisé !"
            font.bold:true
            color: "#2E5245"
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            anchors {
                top: circleSuccess.bottom
                topMargin: 50
                horizontalCenter: parent.horizontalCenter
            }
            font.pixelSize: 30
            z: 2
        }
    }
}