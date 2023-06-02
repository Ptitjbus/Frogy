from Tests import *
from Log import *
from FrogyThread import *
from GPT import *
import json


class Frogy:
    def __init__(self, server, backend, testMode=False) -> None:
        self.server = server
        self.server.addMessageFunction(self.onMessageCallback)
        self.backend = backend
        self.testMode = testMode #mock
        self.gpt = ChatGPT(self.backend)
        self.frogyThread = FrogyThread(self.backend)
        # Chat GPT
        # Backend
        # Watcher
        # Speaker


    def start(self):
        self.server.start()
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
        else:
            printDanger("Erreur lors de la lecture des réponses de GPT")

        # send tips tts request
        if( not self.testMode and gptresponse["tips"]):
            self.backend.speaker.generateTips(gptresponse["tips"])
            self.backend.addTipsFunction(gptresponse["tips"])
        else:     
            printDanger("Erreur lors de la lecture des tips")

    def launchTests(self):
        test = Test(self.server)
        test.runTest()
