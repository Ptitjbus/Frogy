import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.2
import QtMultimedia 5.12

Item {  
    id: sleepScreenItem
    width: 1024
    height: 600
    property alias alertText: alertText.text
    property alias isVisible: sleepScreen.visible

    Rectangle {
        id: sleepScreen
        color: "#ED6A58"
        anchors.fill: parent
        visible: false
        z:2

        Image {
            id: frogyFaceSleep
            width: 300
            height: 300
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "../assets/emotes/ExclamationRed.png"
            fillMode: Image.PreserveAspectFit
        }

        MediaPlayer {
            id: alertMediaPlayer
            source: "../assets/emotes/ExclamationRed.webm"
            autoPlay: true
            loops: MediaPlayer.Infinite
        }

        VideoOutput {
            id: videoOutputAlert
            source: alertMediaPlayer
            width: 300
            height: 300
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fillMode: VideoOutput.PreserveAspectFit // Garde le ratio de l'aspect d'origine
            z: 1 // Assurez-vous que la vidéo est en dessous du texte
        }

        Text {
            id: alertText
            font.bold:true
            color: "#FDF3E8"
            width: parent.width - 100
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            anchors {
                top: videoOutputAlert.bottom
                topMargin: 50
                horizontalCenter: parent.horizontalCenter
            }
            font.pixelSize: 30
            z: 2
        }    
    }
}