from Tests import *
from Log import *
from FrogyThread import *
from GPT import *
import json
from Speaker import *
from Backend import *
from FrogySleepThread import *

class Frogy:
    def __init__(self, engine) -> None:
        self.testMode = False #mock
        self.engine = engine
        self.backend = Backend(self.engine)
        self.gpt = ChatGPT(self.backend)
        self.frogyThread = FrogyThread(self.backend)
        self.speaker = Speaker(self.backend)
        self.currentTipsId = 0
        self.currentSorting = "date"
        engine.rootContext().setContextProperty("backend", self.backend)
        self.isFrogySleep = True
        self.frogySleepThread = FrogySleepThread(self.setFrogySleep)

    def start(self):
        self.frogyThread.start()
        self.frogySleepThread.start()
        if self.testMode == True:
            self.launchTests()
        # lance le compteur

    def onMessageCallback(self, message):
        self.frogySleepThread.restartCounter()
        self.setFrogySleep(False)
        if self.testMode:
            gptresponse = {
                "list": [
                    {"name": "Tomates", "date": "5"},
                    {"name": "Salade", "date": "4"},
                    {"name": "Fromage rapé", "date": "15"},
                    {"name": "Steak", "date": "1"},
                    {"name": "Crème fraîche mama mia que se bueno", "date": "0"},
                    {"name": "Oeufs", "date": "-2"},
                ],
                "tips": [
                    "Conserver les tomates à température ambiante, pas au réfrégirateur",
                    "Utiliser les tomates les plus mûres en premier",
                    "Ne pas laisser les tomates trop longtemps exposées à la lumière",
                ],
            }
        else:
            messageResult = json.loads(message)
            gptresponse = self.gpt.convertList(
                messageResult["date"], messageResult["list"]
            )

        # update frogy display
        try:
            for elem in gptresponse["list"]:
                self.backend.addItem(elem)
            self.backend.sortListByDate(False)
            self.currentSorting = "date"
            self.backend.changeDisplayResultSyncScreen(True)
        except:
            printDanger("Erreur lors de la lecture des réponses de GPT")
            self.backend.changeDisplayResultSyncScreen(False)

        # send tips tts request
        try:
            self.speaker.generateTips(gptresponse["tips"])
            self.backend.addTipsFunction(gptresponse["tips"])            
        except:     
            printDanger("Erreur lors de la lecture des tips")

    def launchTests(self):
        pass
        # test = Test(self.server)
        # test.runTest()
    
    def setFrogySleep(self,state):
        self.backend.displaySleepScreenFunction(state)
        self.isFrogySleep = state

    def hardwareCallback(self, callback):
        self.frogySleepThread.restartCounter()
        if(self.isFrogySleep):
            self.setFrogySleep(False)
            return

        if(callback['input'] == 'wheel'):
            if(callback['type'] == 'rotation'):
                if(callback['state'] == 'up'):
                    self.backend.moveSelectionUp.emit()
                elif(callback['state'] == 'down'):
                    self.backend.moveSelectionDown.emit()
            elif(callback['type'] == 'click'):
                self.backend.encoderButtonClicked.emit()
        elif(callback['input'] == 'button'):
            if(callback['type'] == 'return'):
                self.backend.returnBtnFunction()
            elif(callback['type'] == 'tips'):
                
                if(self.speaker.ready):
                    self.backend.displayTips.emit(self.currentTipsId)
                    self.speaker.say(self.currentTipsId)
                else:
                    self.backend.displayTips.emit(9999)

                    
                if(self.currentTipsId == len(self.speaker.tipsFiles) - 1):
                    self.currentTipsId = 0
                else:
                    self.currentTipsId += 1
            elif(callback['type'] == 'sort'):
                if(self.currentSorting == "date"):
                    self.backend.sortListByName()
                    self.currentSorting = "name"
                elif(self.currentSorting == "name"):
                    self.backend.sortListByDate(True)
                    self.currentSorting = "date"
