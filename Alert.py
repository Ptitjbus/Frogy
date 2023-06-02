class AlertDelegate:
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    RESET = "\033[0m"

    def __init__(self) -> None:
        pass

    def updateAlertState(self):
        pass

    def danger(self, log, details=None):
        print(f"{self.RED}{log}{self.RESET}")

    def warning(self, log, details=None):
        print(f"{self.YELLOW}{log}{self.RESET}")

    def success(self, log, details=None):
        print(f"{self.GREEN}{log}{self.RESET}")

    def alertPrint(self, state):
        # print(type(state))
        print(state.description())
