import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.2

Window {
    id: window
    width: 640
    height: 380
    title: qsTr("Frogy")
    visible: true    

    property var tips: []
    property var isSynchronisationLoadingVisible : false
    property var isSynchronisationSuccessVisible : false

    RowLayout {
        anchors.fill: parent

        ColumnLayout {
            id: col1
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 2 * window.width / 5
            

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                

                Image {
                    id: frogyFace
                    anchors.centerIn: parent
                    source: "frogy_Idle.png"
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        ColumnLayout {
            id: col2
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 3 * window.width / 5

            ListModel {
                id: myList
            }

            Item {
                anchors.fill: parent

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
                            color: "#E2E8F0"
                            border.width: 2
                            border.color: listView.currentIndex === index ? "#485877" : "transparent"                            
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
                                    }
                                }

                                Rectangle {
                                    id: dateLabel
                                    radius: 10
                                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                    width: textLabel.width + 20
                                    Layout.preferredHeight: itemDelegate.height / 3
                                    color: {
                                        if (model.dateRemaining < 0)
                                            return "#F87171";
                                        else if (model.dateRemaining === 0)
                                            return "#FDBA74";
                                        else if (model.dateRemaining >= 1 && model.dateRemaining <= 3)
                                            return "#FFE76B";
                                        else 
                                            return "#CBD5E1";
                                    }

                                    Text {
                                        id: textLabel
                                        font.pixelSize: 30
                                        font.bold: true
                                        anchors.centerIn: parent

                                        color: "#2E5245"

                                        text: {
                                            if (model.dateRemaining < 0)
                                                return "A vérifier";
                                            else if (model.dateRemaining === 0)
                                                return "Moins de 24h";
                                            else if (model.dateRemaining >= 1 && model.dateRemaining <= 3)
                                                return "1 à 3 jours";
                                            else if (model.dateRemaining >= 4 && model.dateRemaining <= 7)
                                                return "4 à 7 jours";
                                            else if (model.dateRemaining >= 8 && model.dateRemaining <= 14)
                                                return "1 à 2 semaines";
                                            else if (model.dateRemaining >= 15 && model.dateRemaining <= 28)
                                                return "2 à 4 semaines";
                                            else if (model.dateRemaining >= 29 && model.dateRemaining <= 90)
                                                return "1 à 3 mois";
                                            else if (model.dateRemaining > 90)
                                                return "> 3 mois";
                                        }
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
                

                Popup {
                    id: infoPopup
                    width: 300
                    height: 150
                    x: (listView.width - width) / 2
                    y: (listView.height - height) / 2
                    visible: false

                    Column {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            id: itemName
                            font.bold: true
                            text: "salut"
                        }

                        Text {
                            id: itemDateAdded
                        }
                    }
                }
            }
        }

        Popup {
            id: tipsPopup
            visible: false
            modal: true
            width: parent.width
            height: parent.height

            property string id
            property string text

            Rectangle {
                width: parent.width
                height: parent.height
                color: "white"

                Column {
                    anchors.fill: parent
                    spacing: 0

                    Rectangle {
                        width: parent.width
                        height: 2 * parent.height / 3
                        Image {
                            id: image
                            anchors.centerIn: parent
                            source: "frogy_Idle.png"
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: parent.height / 3
                        Text {
                            id: tipsText
                            width: parent.width - 60
                            wrapMode: Text.Wrap
                            font.pixelSize: 25
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: "Tips n°"+tipsPopup.id+" : "+tipsPopup.text+""
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }

    }

    SynchronisationLoading{isVisible:isSynchronisationLoadingVisible}
    SynchronisationSuccess{isVisible:isSynchronisationSuccessVisible}

    Connections {
        target: backend
        function onAddListItem(jsonItem) {
            var item = JSON.parse(jsonItem);
            var isListWasEmpty = listView.count === 0
            myList.append(item);

            if(isListWasEmpty){
                listView.currentIndex = 0;
            }
        }

        function onChangeFrogyEmote(emote) {
            switch(emote) {
                case "idle":
                    frogyFace.source = "frogy_Idle.png"
                    break;
                case "sad":
                    frogyFace.source = "frogy_Sad.png"
                    break;
                case "thinking":
                    frogyFace.source = "frogy_Thinking.png"
                    break;
                case "calling":
                    frogyFace.source = "frogy_Calling.png"
                    break;
                case "loading":
                    frogyFace.source = "frogy_Loading.png"
                    break;
                default:
                    console.error("Émotion non reconnue: " + emote);
                    break;
            }
        }


        function onEncoderButtonClicked() {
            var currentIndex = listView.currentIndex            
            infoPopup.visible = true
        }

        function onReturnBtn() {
            if(window.isSynchronisationSuccessVisible){
                window.isSynchronisationSuccessVisible = false
            }

            if(tipsPopup.visible){
                tipsPopup.visible = false
            }

            if(infoPopup.visible){
                infoPopup.visible = false
            }
        }

        function onMoveSelectionUp() {
            listView.moveSelectionUp()
        }

        function onMoveSelectionDown() {
            listView.moveSelectionDown()
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

        function onSortByDate() {
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

        function onUpdateListItems(newList){
            var newListParsed = JSON.parse(newList);

            myList.clear()

            for (var i = 0; i < newListParsed.length; i++) {
                myList.append(JSON.parse(newListParsed[i]));
            }
        }

    
        function onAddTips(tipsList){
            console.log(tipsList[0], typeof(tipsList))
            window.tips = tipsList
        }

        function onDisplayTips(id){
            console.log(id, typeof(id))
            if(id !== 9999){
                tipsPopup.visible = true
                tipsPopup.id = id
                tipsPopup.text = window.tips[id]
            }
        }

        function onDisplayLoadingSyncScreen(){
            window.isSynchronisationLoadingVisible = true
        }

        function onDisplayResultSyncScreen(state){
            window.isSynchronisationLoadingVisible = false
            if(state){
                window.isSynchronisationSuccessVisible = true
            }
        }

    }
}
