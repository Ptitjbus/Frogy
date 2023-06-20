from websocket_server import WebsocketServer
from datetime import datetime
import socket
from PySide2.QtCore import QThread
from Log import *

class ServerWS(QThread):
    def __init__(self,onMessageCallback):
        super().__init__()
        self.port = 8081
        self.host = self.get_local_ip_address()
        self.onMessageCallback = onMessageCallback
        self.server = WebsocketServer(host= self.host,port = self.port)
        self.server.set_fn_new_client(self.new_client)
        self.server.set_fn_client_left(self.client_left)
        self.server.set_fn_message_received(self.message_received)
        self.start()

    def get_local_ip_address(self):
        try:
            with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
                s.connect(('8.8.8.8', 80))
                local_ip = s.getsockname()[0]
            return local_ip
        except Exception as e:
            printDanger("Erreur lors de la récupération de l'adresse IP locale : "+ e)
            return None

    def run(self):
        adress = self.host+":"+str(self.port)
        printInfo(f"Server started at : {adress}")
        self.server.run_forever()
    
    def stop(self):
        self.server.server_socket.close()
        self.terminate()
        self.wait()
        
    # Called for every client connecting (after handshake)
    def new_client(self,client, server):
        dt = datetime.now()
        str_date_time = dt.strftime("%H:%M:%S")
        printInfo("Client connected")
        return {'client': client, 'time': str_date_time, 'state': 'connected'}

    # Called for every client disconnecting
    def client_left(self,client, server):
        dt = datetime.now()
        str_date_time = dt.strftime("%H:%M:%S")
        printInfo("Client disconnected")
        return {'client': client, 'time': str_date_time, 'state': 'disconnected'}

    # Called when a client sends a message
    def message_received(self,client, server, message):
        self.onMessageCallback(message)
        self.lastMessage = message
        if len(message) > 200:
            message = message[:200]+'..'
        printInfo(f"Client({client['id']}) said: {message}")

    def send_message(self, message):
        self.server.send_message_to_all(message)