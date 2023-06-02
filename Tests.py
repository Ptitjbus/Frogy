import socket
import RPi.GPIO as GPIO
import websocket
import socket
import time
from wsServer import *
from Log import *


class Test:
    def __init__(self, server) -> None:
        self.isConnected = False
        self.isCommunication = False
        self.server = server
        self.currentTestState = ConnexionTest(self)
        self.currentTestState.context = self

    def runTest(self):
        self.currentTestState.runTest()

    def updateState(self, newState):
        self.currentTestState = newState
        self.currentTestState.context = self

    def alertState(self, state):
        alertPrint(state)


class TestStates:
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    RESET = "\033[0m"

    def __init__(self, context) -> None:
        self.context = context
        self.error = None

    def runTest(self):
        pass

    def description(self):
        pass


class ConnexionTest(TestStates):
    def runTest(self, host="8.8.8.8", port=53, timeout=5):
        try:
            socket.setdefaulttimeout(timeout)
            socket.socket(socket.AF_INET, socket.SOCK_STREAM).connect((host, port))
            self.context.updateState(CommunicationTest(self))
            self.context.runTest()
        except socket.error as ex:
            self.error = ex
            self.context.alertState(self)

    def description(self):
        return f"{self.RED}Aucune connexion à Internet : {self.error} {self.RESET}"


class CommunicationTest(TestStates):
    def runTest(self):
        try:
            messageSended = "Hello, server !"
            testClient = websocket.create_connection(
                f"ws://{self.context.server.host}:{str(self.context.server.port)}"
            )
            testClient.send(messageSended)
            testClient.close()

            # self.context.updateState(RotaryTest(self))
            # self.context.runTest()
            printSuccess("Tests terminés")
        except Exception as e:
            self.error = e
            self.context.alertState(self)

    def description(self):
        return f"{self.RED}Communication Echouée. {self.error} {self.RESET}"


class RotaryTest(TestStates):
    CLK_PIN = 17
    DT_PIN = 27
    SW_PIN = 22

    def __init__(self, context) -> None:
        super().__init__(context)
        self.isClkRight = False
        self.isClkLeft = False

    def runTest(self):
        GPIO.add_event_detect(
            self.SW_PIN, GPIO.FALLING, callback=self.swCallbackTest, bouncetime=300
        )
        GPIO.add_event_detect(
            self.CLK_PIN, GPIO.BOTH, callback=self.rotationCallbackTest, bouncetime=2
        )

        printInfo("Début des tests de molette")
        start_time = time.time()
        while time.time() - start_time < 5:
            pass

    def swCallbackTest(self, channel):
        printInfo("Molette pressed")

    def rotationCallbackTest(self, channel):
        global clkLastState
        clkState = GPIO.input(self.CLK_PIN)
        dtState = GPIO.input(self.DT_PIN)

        if clkState != clkLastState:
            if dtState == 1 and clkState == 0:  # UP
                self.isClkRight = True
                printInfo("right")
                # pass
            elif dtState == 1 and clkState == 1:  # DOWN
                printInfo("left")
                self.isClkLeft = True
                # pass
        clkLastState = clkState

    def description(self):
        return f"{self.RED}Erreur de molette : {self.error} {self.RESET}"
