import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.2
import QtMultimedia 5.12

Item {  
    id: syncScreenItem
    width: 1024
    height: 600
    property alias isVisible : syncScreen.visible

    Rectangle {
        id: syncScreen
        color: "white"
        anchors.fill: parent
        visible: false
        z:2

        MediaPlayer {
            id: mediaPlayer
            source: "../assets/emotes/Bug.webm"
            autoPlay: true
            loops: MediaPlayer.Infinite
        }

        VideoOutput {
            id: videoOutput
            source: mediaPlayer
            width: 300
            height: 300
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -100
            fillMode: VideoOutput.PreserveAspectFit // Garde le ratio de l'aspect d'origine
            z: 1 // Assurez-vous que la vidéo est en dessous du texte
        }

        Text {
            id: waitingText
            text: "Oups, quelque chose cloche..."
            font.bold:true
            color: "#2E5245"
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            anchors {
                top: videoOutput.bottom
                topMargin: 50
                horizontalCenter: parent.horizontalCenter
            }
            font.pixelSize: 30
            z: 2
        }
    }

    Footer{isReturnVisible:true}
}