# This Python file uses the following encoding: utf-8
import sys
from pathlib import Path
from Frogy import Frogy
from Speaker import *
from wsServer import *
import RPi.GPIO as GPIO
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Signal, Slot
from datetime import datetime
import json

# Set Pins
BUTTON_PIN = 14
CLK_PIN = 17
DT_PIN = 27
SW_PIN = 22
TIPS_BTN = 10

# Init GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setup(BUTTON_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

GPIO.setup(TIPS_BTN, GPIO.IN, pull_up_down = GPIO.PUD_DOWN)

GPIO.setup(CLK_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(DT_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(SW_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

clkLastState = GPIO.input(CLK_PIN)


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
        self.speaker = Speaker(self)
        self.initGPIO()
        self.engine = engine
        self.currentTipsId = 0

    def initGPIO(self, parent=None):
        GPIO.add_event_detect(
            BUTTON_PIN, GPIO.BOTH, callback=self.buttonCallback, bouncetime=300
        )
        GPIO.add_event_detect(
            SW_PIN, GPIO.FALLING, callback=self.swCallback, bouncetime=300
        )
        GPIO.add_event_detect(
            CLK_PIN, GPIO.BOTH, callback=self.rotationCallback, bouncetime=2
        )
        GPIO.add_event_detect(
            TIPS_BTN, GPIO.BOTH, callback=self.tipsBtnCallback, bouncetime=2
        )

    def tipsBtnCallback(self, channel):
        if(self.speaker.ready):
            self.displayTips.emit(self.currentTipsId)
            self.speaker.say(self.currentTipsId)
        else:
            self.displayTips.emit(9999)
        
        if(self.currentTipsId == len(self.speaker.tipsFiles) - 1):
            self.currentTipsId = 0
        else:
            self.currentTipsId += 1

    def buttonCallback(self, channel):
        buttonState = not GPIO.input(channel)
        if buttonState:
            # self.getListData()
            self.returnBtnFunction()

    def swCallback(self, channel):
        self.encoderButtonClicked.emit()

    def changeFrogyFace(self, emote):
        self.changeFrogyEmote.emit(emote)

    def rotationCallback(self, channel):
        global clkLastState
        clkState = GPIO.input(CLK_PIN)
        dtState = GPIO.input(DT_PIN)

        if clkState != clkLastState:
            if dtState == 1 and clkState == 0:  # UP
                self.moveSelectionUp.emit()
            elif dtState == 1 and clkState == 1:  # DOWN
                self.moveSelectionDown.emit()
        clkLastState = clkState

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
