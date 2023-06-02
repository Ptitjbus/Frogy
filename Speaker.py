import subprocess
from Alert import *
import os
import pygame
import re

class Speaker:

    def __init__(self,backend) -> None:
        self.backend = backend
        self.alert = AlertDelegate()
        self.tipsFiles = []
        self.ready = False
        pygame.mixer.init()

    def generateTips(self, tipsList):
        counter = 0
        self.ready = False
        for item in tipsList:        
            command = ["mimic3", "--voice", "fr_FR/siwis_low", item]
            with open(f"tips/test{counter}.wav", "wb") as outfile:
                subprocess.run(command, stdout=outfile)
            counter += 1

        self.backend.changeFrogyFace("thinking")
        self.alert.success("Génération des tips terminé")
        self.ready = True
        print('SPEAKER READY', self.ready)

    def getTips(self):
        self.tipsFiles = []
        tipsDirectory = os.listdir('tips/')
        if not tipsDirectory:
            return None
        else:
            for tips in tipsDirectory:
                self.tipsFiles.append(tips)

            return self.tipsFiles.sort(key=self.extraire_numero)
        
    def extraire_numero(self,fichier):
        return int(re.search(r'\d+', fichier).group())
    
    def say(self,tipsId):
        self.backend.changeFrogyFace("idle")
        tipsList = self.getTips()
        if(tipsList != False):
            pygame.mixer.music.load(f"tips/{self.tipsFiles[tipsId]}")
            pygame.mixer.music.play()

            while pygame.mixer.music.get_busy() == True:
                continue

