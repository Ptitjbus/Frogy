import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.2
import QtMultimedia 5.12

Item {  
    id: tipsScreen
    width: 1024
    height: 600
    property alias tipsText: tipsText.text

    Rectangle {
        color: "white"
        anchors.fill: parent

        Image {
            id: frogyFaceTipsScreen
            width: 300
            height: 300
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -100
            source: "../assets/emotes/Idle.png"
            fillMode: Image.PreserveAspectFit
        }

        MediaPlayer {
            id: mediaPlayerTipsScreen
            source: "../assets/emotes/Idle.webm"
            autoPlay: true
            loops: MediaPlayer.Infinite
        }

        VideoOutput {
            id: videoOutputTipsScreen
            source: mediaPlayerTipsScreen
            width: 300
            height: 300
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -100
            fillMode: VideoOutput.PreserveAspectFit // Garde le ratio de l'aspect d'origine
            z: 1 // Assurez-vous que la vidéo est en dessous du texte
        }

        Text {
            id: tipsText
            font.bold:true
            color: "#2E5245"
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            anchors {
                top: videoOutputTipsScreen.bottom
                topMargin: 50
                horizontalCenter: parent.horizontalCenter
            }
            font.pixelSize: 30
            z: 2
        }        
    }
}