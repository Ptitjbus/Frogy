from Tests import *
from Log import *
from FrogyThread import *
from GPT import *
import json
from Speaker import *
from Backend import *

class Frogy:
    def __init__(self, engine) -> None:
        self.testMode = False #mock
        self.engine = engine
        self.backend = Backend(self.engine)
        self.gpt = ChatGPT(self.backend)
        self.frogyThread = FrogyThread(self.backend)
        self.speaker = Speaker()
        self.currentTipsId = 0
        engine.rootContext().setContextProperty("backend", self.backend)

    def start(self):
        self.frogyThread.start()
        if self.testMode == True:
            self.launchTests()

    def onMessageCallback(self, message):

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
        if(gptresponse["list"]):
            for elem in gptresponse["list"]:
                self.backend.addItem(elem)
            self.backend.sortListByDate()
            self.backend.changeDisplayLoadingScreen(False)
        else:
            printDanger("Erreur lors de la lecture des réponses de GPT")

        # send tips tts request
        if( not self.testMode and gptresponse["tips"]):
            self.speaker.generateTips(gptresponse["tips"])
            self.backend.addTipsFunction(gptresponse["tips"])            
        else:     
            printDanger("Erreur lors de la lecture des tips")

    def launchTests(self):
        pass
        # test = Test(self.server)
        # test.runTest()

    def hardwareCallback(self, callback):
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
                else:
                    self.backend.displayTips.emit(9999)

                self.speaker.say(self.currentTipsId)
                    
                if(self.currentTipsId == len(self.speaker.tipsFiles) - 1):
                    self.currentTipsId = 0
                else:
                    self.currentTipsId += 1

    def phoneCallback(self, callback):
        pass
