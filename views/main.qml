import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.15
import QtMultimedia 5.12

Window {
    id: window
    width: 640
    height: 380
    title: qsTr("Frogy")
    visible: true

    property var tips: []
    property var tipsScreenVisible: false
    property var tipsTextScreen: ""

    property var isSynchronisationLoadingVisible : false
    property var isSynchronisationSuccessVisible : false
    property var isSynchronisationFailedVisible : false

    property var isFooterSortVisible : true
    property var isFooterTipsVisible : true
    property var isFooterSelectVisible : true
    property var isFooterReturnVisible : false
    property var isFooterVisible : false

    property var isSleepScreenVisible: true
    property var isAlertScreenVisible: false
    property var alertScreenSentence: ""
    
    RowLayout {
        anchors.fill: parent

        ColumnLayout {
            id: col1
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 2 * window.width / 5
            

            Item {
                width: parent.width
                height: parent.height
                // Layout.fillWidth: true
                // Layout.fillHeight: true

                Image {
                    id: frogyFace
                    width: 300
                    height: 300
                    anchors.centerIn: parent
                    source: "../assets/emotes/Idle.png"
                    fillMode: Image.PreserveAspectFit
                }

                MediaPlayer {
                    id: frogyFaceMediaPlayer
                    source: "../assets/emotes/Idle.webm"
                    autoPlay: true
                    loops: MediaPlayer.Infinite
                }

                VideoOutput {
                    id: videoOutput
                    source: frogyFaceMediaPlayer
                    width: 300
                    height: 300
                    anchors.centerIn: parent
                    fillMode: VideoOutput.PreserveAspectFit
                    z: 1 // Assurez-vous que la vidéo est en dessous du texte
                }

            }
        }

        ColumnLayout {
            id: col2
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 3 * window.width / 5
            anchors.verticalCenterOffset: -50

            ListModel {
                id: myList
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                ListView {
                    id: listView
                    anchors.fill: parent                    
                    model: myList
                    currentIndex: -1

                    delegate: Item {
                        id:itemDelegate
                        width: listView.width
                        height: listView.height / 5 + 10
                        

                        Rectangle {
                            anchors.fill: parent
                            anchors.rightMargin: 20
                            anchors.leftMargin: 5
                            anchors.topMargin: 5
                            anchors.bottomMargin: 5
                            color: listView.currentIndex === index ? "#2E5245" : "#FDF3E8"                            
                            radius: 5

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10

                                Item {
                                    id: textContainer
                                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                                    Layout.fillWidth: true
                                    Layout.maximumWidth: 350
                                    Layout.preferredHeight: nameLabel.height
                                    
                                    Text {
                                        id: nameLabel
                                        width: parent.width
                                        text: model.name                                        
                                        font.pixelSize: 35
                                        font.bold: true
                                        elide: Text.ElideRight
                                        color: listView.currentIndex === index ? "#FDF3E8" : "#2E5245" 
                                    }
                                }

                                Rectangle {
                                    id: dateLabel
                                    radius: 10
                                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                    width: textLabel.width + 20
                                    Layout.preferredHeight: itemDelegate.height / 3
                                    color: connectionBackend.checkDateLabelColor(model.dateRemaining)

                                    Text {
                                        id: textLabel
                                        font.pixelSize: 30
                                        font.bold: true
                                        anchors.centerIn: parent

                                        color: model.dateRemaining < 0 ? "#FDF3E8"  : "#2E5245"

                                        text: connectionBackend.checkDateLabelText(model.dateRemaining) 
                                    }
                                }

                            }
                        }
                    }                    

                    function moveSelectionUp() {
                        if (listView.currentIndex > 0) {
                            listView.currentIndex -= 1;
                        }
                    }

                    function moveSelectionDown() {
                        if (listView.currentIndex < listView.count - 1) {
                            listView.currentIndex += 1;
                        }
                    }

                    ScrollBar.vertical: ScrollBar {
                        id: scrollBar
                        active: true
                        width: 15
                    }
                }
            }
        }

        Popup {
            id: sortByNamePopup
            width: 400
            height: 300
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            visible: false
            opacity: 0.0 // Initialiser l'opacité à 0

            Timer {
                id: visibilityNameTimer
                interval: 2000
                running: false
                onTriggered: sortByNamePopup.fadeOut()
            }

            function fadeIn() {
                visibilityNameTimer.restart()
                sortByNamePopup.visible = true
                sortByNamePopup.opacity = 1
            }

            function fadeOut() {
                sortByNamePopup.opacity = 0
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 500 // durée de l'animation en millisecondes
                    easing.type: Easing.InOutQuad // type d'animation
                }
            }

            onVisibleChanged: {
                if (visible) {
                    fadeIn()
                } else {
                    visibilityNameTimer.stop()
                }
            }

            background: Rectangle {
                color: "white"
                radius: 10
                layer.enabled: true
                layer.effect: DropShadow {
                    color: "#D2D2D2"
                    radius: 20
                    samples: 16
                    spread: 0.2
                }
            }


            Image {
                id: alphabeticIcon
                width: 100
                height: 100
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -40
                source: "../assets/icons/sortAlphabetic.svg"
                fillMode: Image.PreserveAspectFit
            }            

            Text{
                font.bold:true
                color: "#2E5245"
                text: "Ordre alphabétique"
                width: parent.width -20
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 30
                anchors {
                    top: alphabeticIcon.bottom
                    topMargin: 50
                    horizontalCenter: parent.horizontalCenter
                }
            }
            
        }

        Popup {
            id: sortByDatePopup
            width: 400
            height: 300
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            visible: false
            opacity: 0.0 // Initialiser l'opacité à 0

            Timer {
                id: visibilityDateTimer
                interval: 2000
                running: false
                onTriggered: sortByDatePopup.fadeOut()
            }

            function fadeIn() {
                visibilityDateTimer.restart()
                sortByDatePopup.visible = true
                sortByDatePopup.opacity = 1
            }

            function fadeOut() {
                sortByDatePopup.opacity = 0
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 500 // durée de l'animation en millisecondes
                    easing.type: Easing.InOutQuad // type d'animation
                }
            }

            onVisibleChanged: {
                if (visible) {
                    fadeIn()
                } else {
                    visibilityDateTimer.stop()
                }
            }

            background: Rectangle {
                color: "white"
                radius: 10
                layer.enabled: true
                layer.effect: DropShadow {
                    color: "#D2D2D2"
                    radius: 20
                    samples: 16
                    spread: 0.2
                }
            }


            Image {
                id: dateIcon
                width: 100
                height: 100
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -40
                source: "../assets/icons/sortDate.svg"
                fillMode: Image.PreserveAspectFit
            }            

            Text{
                font.bold:true
                color: "#2E5245"
                text: "Ordre de consommation"
                width: parent.width -20
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 30
                anchors {
                    top: dateIcon.bottom
                    topMargin: 50
                    horizontalCenter: parent.horizontalCenter
                }
            }
            
        }



        Popup {
            id: infoPopup
            width: 500
            height: popUpLabel.height + noChoice.height + yesChoice.height + 120
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2

            property string name
            property int currentIndex: 0 

            background: Rectangle {
                color: "white"
                radius: 10
                layer.enabled: true
                layer.effect: DropShadow {
                    color: "#D2D2D2"
                    radius: 20
                    samples: 16
                    spread: 0.2
                }
            }

            // Le Texte
            Text {
                id: popUpLabel
                width: infoPopup.width -50
                text: "Tu es sur le point de retirer l'article <b>"+ infoPopup.name +"</b> de ta liste de produit"
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                anchors.top: parent.top
                anchors.topMargin: 20
                font.pixelSize: 25
                color: "#2E5245"
                textFormat: Text.RichText
            }

            // Le premier rectangle
            Rectangle {
                id: noChoice
                width: infoPopup.width -50
                height: 75
                color: "#FBF4E8"
                anchors.top: popUpLabel.bottom
                anchors.topMargin: 50
                radius:5
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                border.width: infoPopup.currentIndex == 0 ? 2 : 0 
                border.color: "#ED6A58"

                // Le Texte dans le rectangle
                Text {
                    text: "Non"
                    anchors.centerIn: parent
                    color: "#2E5245"
                    font.bold: true
                    font.pixelSize: 25
                }
            }

            // Le deuxième rectangle
            Rectangle {
                id: yesChoice
                // width: infoPopup.currentIndex == 1 ? 400 : 300
                width: infoPopup.width -50
                height: 75
                color: "#FBF4E8"
                anchors.top: noChoice.bottom
                anchors.topMargin: 10
                radius:5
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                border.width: infoPopup.currentIndex == 1 ? 2 : 0 
                border.color: "#ED6A58"

                // Le Texte dans le rectangle
                Text {
                    text: "Oui, retirer"
                    anchors.centerIn: parent
                    color: "#ED6A58"
                    font.bold: true
                    font.pixelSize: 25
                }
            }

            
            function moveSelectionUp() {
                if (currentIndex == 1) {
                    currentIndex = 0;
                }
            }

            function moveSelectionDown() {
                if (currentIndex == 0) {
                    currentIndex = 1;
                }
            }
        }


    }

    Tips{visible: tipsScreenVisible; tipsText: tipsTextScreen}
    SynchronisationLoading{isVisible:isSynchronisationLoadingVisible}
    SynchronisationSuccess{isVisible:isSynchronisationSuccessVisible}
    SynchronisationFailed{isVisible:isSynchronisationFailedVisible}
    SleepScreen{isVisible:isSleepScreenVisible}
    AlertSleepScreen{isVisible:isAlertScreenVisible; alertText: alertScreenSentence}

    Footer {
        visible: isFooterVisible;
        isSortVisible: isFooterSortVisible;
        isTipsVisible: isFooterTipsVisible;
        isSelectVisible: isFooterSelectVisible;
        isReturnVisible: isFooterReturnVisible
    }


    Connections {
        id: connectionBackend
        target: backend

        function onAddListItem(jsonItem) {
            var item = JSON.parse(jsonItem);
            var isListWasEmpty = listView.count === 0
            myList.append(item);

            if(isListWasEmpty){
                listView.currentIndex = 0;
            }
        }

        function onDisplaySleepScreen(state){
            infoPopup.close()
            if(state){
                window.isSleepScreenVisible = true
                window.isFooterVisible = false
            } else {
                window.isSleepScreenVisible = false
                if(window.isSynchronisationSuccessVisible){
                    window.isFooterVisible = false
                }
                window.isFooterVisible = true

            }
        }

        function onDisplayAlertScreen(state, alertItems){
            infoPopup.close()
            var sentence = ""
            if(alertItems.count > 1){
                for (var i = 0; i < alertItems.count; i++) {
                    
                    if(i == alertItems.count -1){
                        sentence = sentence + alertItems[i] + " "
                    }else{
                        sentence = sentence + alertItems[i] + ", "
                    }
                }
                sentence = "Les" + sentence + "ne sont peut être plus commestibles, tu devrais vérifier ! "
            }else{
                sentence = `${alertItems[0]} n'est peut être plus commestible tu devrais vérifier`
            }
            
            window.alertScreenSentence = sentence
            if(state){
                window.isAlertScreenVisible = true
                window.isFooterVisible = false
            } else {
                window.isAlertScreenVisible = false
                if(window.isSynchronisationSuccessVisible){
                    window.isFooterVisible = false
                }
                window.isFooterVisible = true

            }
        }

        function onChangeFrogyEmote(emote) {
            switch(emote) {
                case "idle":
                    frogyFace.source = "../assets/emotes/Idle.png"
                    frogyFaceMediaPlayer.source = "../assets/emotes/Idle.webm"
                    break;
                case "bug":
                    frogyFace.source = "../assets/emotes/bug.png"
                    frogyFaceMediaPlayer.source = "../assets/emotes/bug.webm"
                    break;
                case "tips":
                    frogyFace.source = "../assets/emotes/Tips.png"
                    frogyFaceMediaPlayer.source = "../assets/emotes/Tips.webm"
                    break;
                case "exclamation":
                    frogyFace.source = "../assets/emotes/Exclamation.png"
                    frogyFaceMediaPlayer.source = "../assets/emotes/Exclamation.webm"
                    break;
                case "sleep":
                    frogyFace.source = "../assets/emotes/Sleep.png"
                    frogyFaceMediaPlayer.source = "../assets/emotes/Sleep.webm"
                    break;
                default:
                    console.error("Émotion non reconnue: " + emote);
                    break;
            }
        }


        function onEncoderButtonClicked() {
            if(myList.count > 0){
                var currentIndex = listView.currentIndex
                var item = myList.get(currentIndex)
                infoPopup.name = item.name

                if(window.isSynchronisationSuccessVisible || window.isSynchronisationFailedVisible || window.isSynchronisationLoadingVisible || window.tipsScreenVisible){
                    return
                }

                if(infoPopup.visible){
                    if (infoPopup.currentIndex === 1) {
                        myList.remove(currentIndex)
                    }

                    infoPopup.close()
                    
                    window.isFooterVisible = true
                    window.isFooterSortVisible = true
                    window.isFooterTipsVisible = true
                    window.isFooterSelectVisible = true
                    window.isFooterReturnVisible = false
                } else {
                    infoPopup.visible = true
                    window.isFooterVisible = true
                    window.isFooterSortVisible = false
                    window.isFooterTipsVisible = false
                    window.isFooterSelectVisible = true
                    window.isFooterReturnVisible = true
                }    
            }        
        }

        function onReturnBtn() {
            if(window.isSynchronisationSuccessVisible){
                window.isSynchronisationSuccessVisible = false
            }

            if(window.isSynchronisationFailedVisible){
                window.isSynchronisationFailedVisible = false
            }

            if(infoPopup.visible){
                infoPopup.visible = false
            }

            if(window.tipsScreenVisible){
                window.tipsScreenVisible = false
            }

            window.isFooterVisible = true
            window.isFooterSortVisible = true
            window.isFooterTipsVisible = true
            window.isFooterSelectVisible = true
            window.isFooterReturnVisible = false
        }

        function onMoveSelectionUp() {
            if(infoPopup.visible == false){
                listView.moveSelectionUp()
            }else{
                infoPopup.moveSelectionUp()
            }
        }

        function onMoveSelectionDown() {
            if(infoPopup.visible == false){
                listView.moveSelectionDown()
            }else{
                infoPopup.moveSelectionDown()
            }
        }

        function onRequestListData() {
            var listData = []
            for (var i = 0; i < myList.count; i++) {
                var item = myList.get(i);
                var itemData = {"id": i, "name": item.name,"dateAdded": item.dateAdded, "date": item.dateRemaining};
                listData.push(itemData)
            }
            backend.receiveListData(listData)
        }

        function onSortByDate(state) {
            if(!tipsScreenVisible && !isSynchronisationLoadingVisible && !isSynchronisationSuccessVisible && !isSynchronisationFailedVisible){
                if(state){
                    sortByDatePopup.fadeIn()
                }
                var array = []
                for (var i = 0; i < myList.count; i++) {
                    let item = myList.get(i)
                    array.push({name: item.name, dateAdded: item.dateAdded, dateRemaining: item.dateRemaining})
                }

                array.sort(function(a, b) {
                    return a.dateRemaining - b.dateRemaining;
                })

                myList.clear()

                for (var i = 0; i < array.length; i++) {
                    myList.append(array[i])
                }
            }
        }

        function onSortByName() {
            if(!tipsScreenVisible && !isSynchronisationLoadingVisible && !isSynchronisationSuccessVisible && !isSynchronisationFailedVisible){
                sortByNamePopup.fadeIn()

                var array = []
                for (var i = 0; i < myList.count; i++) {
                    let item = myList.get(i)
                    array.push({name: item.name, dateAdded: item.dateAdded, dateRemaining: item.dateRemaining})
                }

                array.sort(function(a, b) {
                    if (a.name < b.name) {
                        return -1;
                    }
                    if (a.name > b.name) {
                        return 1;
                    }
                    return 0; //les noms sont égaux
                })

                myList.clear()

                for (var i = 0; i < array.length; i++) {
                    myList.append(array[i])
                }
            }
        }


        function onUpdateListItems(newList){
            var newListParsed = JSON.parse(newList);

            myList.clear()

            for (var i = 0; i < newListParsed.length; i++) {
                myList.append(JSON.parse(newListParsed[i]));
            }
        }

    
        function onAddTips(tipsList){
            window.tips = tipsList
        }

        function onDisplayTips(id){

            if(id !== 9999){
                window.tipsScreenVisible = true
                window.tipsTextScreen = window.tips[id]

                window.isFooterVisible = true
                window.isFooterSortVisible = false
                window.isFooterTipsVisible = true
                window.isFooterSelectVisible = false
                window.isFooterReturnVisible = true
            }

        }

        function onDisplayLoadingSyncScreen(){
            window.isSynchronisationLoadingVisible = true
            window.isFooterVisible = false
        }

        function onDisplayResultSyncScreen(state){
            window.isSynchronisationLoadingVisible = false
            if(state){
                window.isSynchronisationSuccessVisible = true
                window.isFooterVisible = false
            }else{
                window.isFooterVisible = true
                window.isSynchronisationFailedVisible = true
                window.isFooterSortVisible = false
                window.isFooterTipsVisible = false
                window.isFooterSelectVisible = false
                window.isFooterReturnVisible = true
            }
        }

        function checkDateLabelColor(dateRemaining){
             if (dateRemaining < 0)
                return "#F87171";
            else if (dateRemaining === 0)
                return "#FDBA74";
            else if (dateRemaining >= 1 && dateRemaining <= 3)
                return "#FFE76B";
            else 
                return "#CBD5E1";
        }

        function checkDateLabelText(dateRemaining){
            if (dateRemaining < 0)
                return "A vérifier";
            else if (dateRemaining === 0)
                return "Moins de 24h";
            else if (dateRemaining >= 1 && dateRemaining <= 3)
                return "1 à 3 jours";
            else if (dateRemaining >= 4 && dateRemaining <= 7)
                return "4 à 7 jours";
            else if (dateRemaining >= 8 && dateRemaining <= 14)
                return "1 à 2 semaines";
            else if (dateRemaining >= 15 && dateRemaining <= 28)
                return "2 à 4 semaines";
            else if (dateRemaining >= 29 && dateRemaining <= 90)
                return "1 à 3 mois";
            else if (dateRemaining > 90)
                return "> 3 mois";
        }
    }
}
