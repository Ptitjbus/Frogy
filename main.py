# This Python file uses the following encoding: utf-8
import sys
from pathlib import Path
from Frogy import Frogy
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from Hardware import *
from wsServer import *


def main():
    # init the engine
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # init froggy
    frogy = Frogy(engine)
    frogy.start()

    # hardware controller
    Hardware(frogy.hardwareCallback)
    ServerWS(frogy.onMessageCallback)


    # init the display
    qml_file = Path(__file__).resolve().parent / "./views/main.qml"
    engine.load(str(qml_file))
    if not engine.rootObjects():
        sys.exit(-1)

    window = engine.rootObjects()[0]
    
    # Afficher la fenêtre en plein écran
    window.showFullScreen()

    sys.exit(app.exec_())


if __name__ == "__main__":
    main()
