RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
RESET = "\033[0m"
BLUE = "\033[34m"

def __init__(self) -> None:
    pass


def printDanger(self, log, details=None):
    print(f"{RED}{log}{RESET}")

def printWarning(self, log, details=None):
    print(f"{YELLOW}{log}{RESET}")

def printSuccess(self, log, details=None):
    print(f"{GREEN}{log}{RESET}")

def printInfo(self, log, details= None):
    print(f"{BLUE}{log}{RESET}")

def alertPrint(self, state):
    # print(type(state))
    print(state.description())