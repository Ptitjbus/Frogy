import RPi.GPIO as GPIO
import time

# Set Pins
CLK_PIN = 17
DT_PIN = 27
SW_PIN = 22
TIPS_BTN = 10
RETURN_BTN = 5
SORT_BTN = 6

# Init GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setup(RETURN_BTN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

GPIO.setup(TIPS_BTN, GPIO.IN, pull_up_down = GPIO.PUD_UP)

GPIO.setup(SORT_BTN, GPIO.IN, pull_up_down = GPIO.PUD_UP)

GPIO.setup(CLK_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(DT_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(SW_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

clkLastState = GPIO.input(CLK_PIN)

class Hardware:
    def __init__(self,callbackFunction) -> None:
        self.callbackDelegate = callbackFunction
        self.initGPIO()
        self.last_callback_time = 0

    def initGPIO(self, parent=None):

        GPIO.add_event_detect(
            RETURN_BTN, GPIO.BOTH, callback=self.returnCallback, bouncetime=300
        )
        GPIO.add_event_detect(
            SW_PIN, GPIO.FALLING, callback=self.swCallback, bouncetime=300
        )
        GPIO.add_event_detect(
            CLK_PIN, GPIO.BOTH, callback=self.rotationCallback, bouncetime=2
        )
        GPIO.add_event_detect(
            TIPS_BTN, GPIO.RISING, callback=self.tipsBtnCallback, bouncetime=300
        )
        GPIO.add_event_detect(
            SORT_BTN, GPIO.RISING, callback=self.sortBtnCallback, bouncetime=300
        )


    def returnCallback(self, channel):
        buttonState = not GPIO.input(channel)
        if buttonState:
            self.callbackDelegate({'input':'button','state':'pressed','type':'return'})

    def swCallback(self, channel):
        self.callbackDelegate({'input':'wheel','state':'pressed','type':'click'})
    
    def sortBtnCallback(self, channel):
        self.callbackDelegate({'input':'button','state':'pressed','type':'sort'})

    def rotationCallback(self, channel):
        global clkLastState
        clkState = GPIO.input(CLK_PIN)
        dtState = GPIO.input(DT_PIN)

        if clkState != clkLastState:
            if dtState == 1 and clkState == 0:  # UP
                self.callbackDelegate({'input':'wheel','state':'up','type':'rotation'})
            elif dtState == 1 and clkState == 1:  # DOWN
                self.callbackDelegate({'input':'wheel','state':'down','type':'rotation'})
        clkLastState = clkState

    def tipsBtnCallback(self, channel):
        current_time = time.time()
        if current_time - self.last_callback_time > 1:  # 0.3 secondes
            self.last_callback_time = current_time
            self.callbackDelegate({'input':'button','state':'pressed','type':'tips'})


