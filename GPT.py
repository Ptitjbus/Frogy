import json
import openai
import re
from Log import *


class ChatGPT:
    RED = "\033[31m"
    YELLOW = "\033[33m"
    RESET = "\033[0m"
    GREEN = "\033[32m"

    def __init__(self, backend):
        self.second = True
        self.tentativeCounter = 0
        self.backend = backend

    def send_prompt(self, prompt):
        openai.api_key = "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"

        try:
            completion = openai.ChatCompletion.create(
                model="gpt-3.5-turbo", messages=[{"role": "user", "content": prompt}]
            )
        except Exception as e:
            printDanger(f"Request Failed", e)
            return

        try:
            sentence = completion.choices[0].message.content
            response = self.getJSON(sentence)
            if response is None:
                raise Exception("Erreur lors de la récupération JSON")

            self.backend.changeFrogyFace("idle")
            printSuccess(f"La requête à été correctement reçue", response)
            return response
        except Exception as e:
            printDanger(
                f"La requête à échouée", f"Réponse :{completion}\n\nCode erreur : {e}"
            )
            if self.tentativeCounter <= 3:
                printWarning(f"Nouvelle tentative ({self.tentativeCounter})")
                self.tentativeCounter += 1
                self.send_prompt(prompt)

            printDanger("Le nombre de tentatives maximum est dépassé")

    def getJSON(self, string):
        match = re.search("```(.*?)```", string, re.DOTALL)

        if match:
            string = match.group(1)
        else:
            printWarning(
                f"Aucun JSON formaté dans la chaîne de caractères.", string
            )

        try:
            data = json.loads(string)
            return data
        except json.JSONDecodeError as e:
            printDanger(f"Erreur lors de la conversion en JSON.", e)
            return None

    def updateListPrompt(self, list):
        stringList = ""
        counter = 0
        for elem in list:
            counter += 1
            if counter != len(list):
                stringList += elem + ","
            else:
                stringList += elem + ""
        return stringList

    def convertList(self, date, itemsList):
        itemlist = self.updateListPrompt(itemsList)
        prompt = (
            'En fonction de la liste de courses et de la date que je te donne, réponds moi uniquement un json entouré de ``` sous la forme suivante :{"list": [{"name":"nom du produit","date":"estimation du nombre de jours avant sa péremption, juste le nombre de jours"}],"tips": liste de 5 conseils pour mieux consommer/conserver les produits}. Voici la date : '
            + date
            + " et voici la liste :  "
            + itemlist
            + "."
        )
        printWarning("Lancement prompt chatGPT")
        self.backend.changeDisplayLoadingSyncScreen()
        return self.send_prompt(prompt)
