import threading
import time
from datetime import datetime, timedelta
import json
from Log import *

class FrogyThread(threading.Thread):

    def __init__(self,backend):
        super().__init__()
        self.running = True
        self.backend = backend
        self.emote = "idle"
        self.isAlert = False
        self.alertItems = []
        
    def run(self):
        printWarning("Frogy thread started")
        self.clock = datetime.now()
        while self.running:
            self.backend.getListData() #Lance la fonction de récupération des infos
            frogyData = self.backend.frogyData #Récupère les infos
            currentDate = datetime.now().strftime("%d-%m-%Y") #Récupère la date actuelle en jj-mm-yyyy
            # faire en sorte que la date augmente plus vite pour les tests
            updatedList = []

            if frogyData != None:
                for item in frogyData:
                    daysRemaining = self.calculateDays(item['dateAdded'], currentDate, item['date'])
                    daysRemaining= daysRemaining -1
                    updatedItem = json.dumps({'name': item['name'], 'dateAdded': item['dateAdded'], 'dateRemaining': daysRemaining})
                    updatedList.append(updatedItem)
                    if(daysRemaining <= 0):
                        self.emote = "exclamation"
                        self.alertItems.append(item['name'])
                        self.isAlert = True
                    else:
                        self.isAlert = False
                
                if(len(updatedList) > 0):
                    self.backend.updateListFunction(updatedList) #met à jours la liste dans froggy 

            self.backend.changeFrogyFace(self.emote)
            time.sleep(5) #toutes les heures

    def stop(self):
        if(self.running):
            printWarning("Frogy thread stopped")
            self.running = False

    def calculateDays(self, dateAdded, dateCurrent, conservationDays):
        # Format de la date
        date_format = "%d-%m-%Y"
        
        # Conversion des chaînes de caractères en dates
        dateA = datetime.strptime(dateAdded, date_format)
        dateC = datetime.strptime(dateCurrent, date_format)

        dateA += timedelta(days=int(conservationDays))
        
        # Calcul de la différence de jours
        difference = dateA - dateC
        
        return difference.days