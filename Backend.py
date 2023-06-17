from PySide2.QtCore import QObject, Signal, Slot
from datetime import datetime
import json

class Backend(QObject):
    addListItem = Signal(str)
    returnBtn = Signal()
    moveSelectionUp = Signal()
    moveSelectionDown = Signal()
    encoderButtonClicked = Signal()
    changeFrogyEmote = Signal(str)
    requestListData = Signal()
    sortByDate = Signal(bool)
    sortByName = Signal()
    updateListItems = Signal(str)
    addTips = Signal(list)
    displayTips = Signal(int)
    displayLoadingSyncScreen = Signal()
    displayResultSyncScreen = Signal(bool)
    displaySleepScreen = Signal(bool)

    def __init__(self, engine):
        super().__init__()
        self.last_direction = None
        self.frogyData = None
        self.engine = engine
        self.currentTipsId = 0

    def changeFrogyFace(self, emote):
        self.changeFrogyEmote.emit(emote)

    @Slot()
    def addItem(self, item):
        currentTime = datetime.now().strftime("%d-%m-%Y")
        newItem = json.dumps(
            {
                "name": item["name"],
                "dateAdded": currentTime,
                "dateRemaining": int(item["date"]),
            }
        )
        self.addListItem.emit(newItem)

    @Slot()
    def returnBtnFunction(self):
        self.returnBtn.emit()

    def getListData(self):
        self.requestListData.emit()

    @Slot(list)
    def receiveListData(self, data):
        self.frogyData = data

    def sortListByDate(self, state):
        self.sortByDate.emit(state)
    
    def sortListByName(self):
        self.sortByName.emit()

    def updateListFunction(self, newList):
        self.updateListItems.emit(json.dumps(newList))

    def addTipsFunction(self, tipsList):
        self.addTips.emit(tipsList)

    def displayTipsFunction(self, tipsId):
        self.displayTips.emit(tipsId)
    
    def changeDisplayLoadingSyncScreen(self):
        self.displayLoadingSyncScreen.emit()

    def changeDisplayResultSyncScreen(self,state):
        self.displayResultSyncScreen.emit(state)
    
    def displaySleepScreenFunction(self, state):
        self.displaySleepScreen.emit(state)