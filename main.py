# This Python file uses the following encoding: utf-8
import sys
from pathlib import Path
from Frogy import Frogy
from wsServer import *
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Signal, Slot
from datetime import datetime
import json
from Hardware import *


class Backend(QObject):
    addListItem = Signal(str)
    returnBtn = Signal()
    moveSelectionUp = Signal()
    moveSelectionDown = Signal()
    encoderButtonClicked = Signal()
    changeFrogyEmote = Signal(str)
    requestListData = Signal()
    sortByDate = Signal()
    updateListItems = Signal(str)
    addTips = Signal(list)
    displayTips = Signal(int)

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

    def sortListByDate(self):
        self.sortByDate.emit()

    def updateListFunction(self, newList):
        self.updateListItems.emit(json.dumps(newList))

    def addTipsFunction(self, tipsList):
        self.addTips.emit(tipsList)

    def displayTipsFunction(self, tipsId):
        self.displayTips.emit(tipsId)


def main():
    # init the engine
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # create the server
    server = ServerWS(port=8081)

    # create the backend
    backend = Backend(engine)
    engine.rootContext().setContextProperty("backend", backend)

    # init froggy
    frogy = Frogy(server, backend, testMode=False)
    frogy.start()

    # hardware controller
    hardware = Hardware(frogy.hardwareCallback)

    # init the display
    qml_file = Path(__file__).resolve().parent / "main.qml"
    engine.load(str(qml_file))
    if not engine.rootObjects():
        sys.exit(-1)

    window = engine.rootObjects()[0]
    
    # Afficher la fenêtre en plein écran
    window.showFullScreen()

    sys.exit(app.exec_())


if __name__ == "__main__":
    main()
