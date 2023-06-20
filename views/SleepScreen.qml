import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.2
import QtMultimedia 5.12

Item {  
    id: sleepScreenItem
    width: 1024
    height: 600
    property alias isVisible : sleepScreen.visible

    Rectangle {
        id: sleepScreen
        color: "white"
        anchors.fill: parent
        visible: false
        z:2

        Image {
            id: frogyFaceSleep
            width: 300
            height: 300
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "../assets/emotes/Sleep.png"
            fillMode: Image.PreserveAspectFit
        }

        MediaPlayer {
            id: mediaPlayer
            source: "../assets/emotes/Sleep.webm"
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
            fillMode: VideoOutput.PreserveAspectFit // Garde le ratio de l'aspect d'origine
            z: 1 // Assurez-vous que la vidéo est en dessous du texte
        }
    }
}