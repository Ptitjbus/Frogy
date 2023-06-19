import time
import threading
from Log import *

class FrogySleepThread(threading.Thread):

    def __init__(self,callBackFunciton):
        super().__init__()
        self.callBackFunciton = callBackFunciton
        self.running = True
        self.start_time = time.time()

    def run(self):
        printWarning("Frogy thread started")
        while self.running:
            if time.time() - self.start_time >= 60:  # Si plus de 2 minutes se sont écoulées
                self.callBackFunciton(True)
            time.sleep(1)

    def restartCounter(self):
        self.start_time = time.time()

    def stop(self):
        if(self.running):
            printWarning("Frogy thread stopped")
            self.running = False