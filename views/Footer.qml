import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

Rectangle {
    id: footer
    width: parent.width
    height: 50
    color: "white"
    anchors.bottom: parent.bottom
    z:10

    property alias isSortVisible: sortItem.visible
    property alias isTipsVisible: tipsItem.visible
    property alias isSelectVisible: selectItem.visible
    property alias isReturnVisible: returnItem.visible

    visible : false

    layer.enabled: true
    layer.effect: DropShadow {
        anchors.fill: source
        color: "#F2F2F2"
        radius: 8.0
        samples: 16
        source: footer
        verticalOffset: -5.0
        fast: true
    }

    RowLayout {
        id: commandLayout
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10


        Item {
            id:sortItem
            width: sortTextFooter.width + 50
            height: 50
            Layout.alignment: Qt.AlignCenter
            visible:false

            Image {
                id: sortIconFooter
                width: 25
                height: 25
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                source: "../assets/icons/iconFilter.svg"
            }

            Text {
                id: sortTextFooter
                anchors.left: sortIconFooter.right
                anchors.verticalCenter: sortIconFooter.verticalCenter                    
                text: "Trier"
                font.pixelSize: 16
                color: "#2E5245"
                leftPadding: 5
            }
        }

        Item {
            id:tipsItem
            width: tipsTextFooter.width + 50
            height: 50
            Layout.alignment: Qt.AlignCenter
            visible:false

            Image {
                id: tipsIconFooter
                width: 25
                height: 25
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                source: "../assets/icons/iconTips.svg"
            }

            Text {
                id: tipsTextFooter
                anchors.left: tipsIconFooter.right
                anchors.verticalCenter: tipsIconFooter.verticalCenter                    
                text: "Ecouter un conseil"
                font.pixelSize: 16
                color: "#2E5245"
                leftPadding: 5
            }
        }

        Item {
            id:selectItem
            width: selectTextFooter.width + 50
            height: 50
            Layout.alignment: Qt.AlignCenter
            visible:false

            Image {
                id: selectIconFooter
                width: 25
                height: 25
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                source: "../assets/icons/iconClick.svg"
            }

            Text {
                id: selectTextFooter
                anchors.left: selectIconFooter.right
                anchors.verticalCenter: selectIconFooter.verticalCenter                    
                text: "Sélectionner"
                font.pixelSize: 16
                color: "#2E5245"
                leftPadding: 5
            }
        }

        Item {
            id:returnItem
            width: returnTextFooter.width + 50
            height: 50
            Layout.alignment: Qt.AlignCenter
            visible:false

            Image {
                id: returnIconFooter
                width: 25
                height: 25
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                source: "../assets/icons/iconReturn.svg"
            }

            Text {
                id: returnTextFooter
                anchors.left: returnIconFooter.right
                anchors.verticalCenter: returnIconFooter.verticalCenter                    
                text: "Retour"
                font.pixelSize: 16
                color: "#2E5245"
                leftPadding: 5
            }
        }
    }
}
