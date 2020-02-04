import  json
import pandas as pd
import os
import datetime

#Sciezka do katalogu "messenger/inbox" w naszych danych pobranych z fb
#np.: folder_messenger = "/home/piotr/Programowanie/Projekt_twd_2/dane/messages/inbox"
folder_messenger = "/home/piotr/Programowanie/Projekt_twd_2/dane/messages/inbox"

#Pusta wynikowa ramka danych wszystkich wiadomosci z messengera (wyslanych i odebranych)
result = pd.DataFrame()

#Dla kazdego podkatalogu folderu "inbox"
for d in os.listdir(folder_messenger):
    
    #Jesli nazwa pisana malymi literami (wtedy folder zawiera json-a z wiadomosciami, a nie multimedia)
    #if (not d.islower()):
    #    continue
    #Sciezka katalogu naszego rozmowcy
    folder = os.path.join(folder_messenger, d)
    
    for f in os.listdir(folder):
        if not f.endswith('.json'):
            continue
        
        #Sciezka do pliku z wiadomosciami
        plik = os.path.join(folder, f)
                
        #Wczytanie pliku json
        with open(plik) as dane_json:
            dane = json.load(dane_json)
        
        #Utworzenie ramki danych z wszystkimi wiadomosciami z pliku 
        # (czyli w praktyce moich z konkretnym uzytkownikiem)
        df = pd.DataFrame.from_dict(dane['messages'], orient="columns")
        
        #Poprawa kodowania polskich znakow dla tresci i nadawcy
        if('content' in df.iloc[0]):
            df['content'] = df['content'].map(lambda content: str(content).encode('latin1').decode('utf8'))
        df['sender_name'] = df['sender_name'].map(lambda content: str(content).encode('latin1').decode('utf8'))
        
        #Odczytanie daty z timestamp-a
        df['timestamp_ms'] = df['timestamp_ms'].map(lambda data: datetime.datetime.fromtimestamp(data/1000))
        
        #Dodanie kolumny rozmowcy bo oryginalnie mamy tylko nadawce
        if(len(dane['participants'])>2):
            df['rozmowca'] = "czat_grupowy"    
        else:
            rozmowca = str(dane['participants'][0]['name'])
            rozmowca = rozmowca.encode('latin1').decode('utf8')
            df['rozmowca'] = rozmowca
        
        #Dopisanie do koncowej ramki
        result = result.append(df)

#!!! Zapis wyniku do csv !!!
#np.:   result.to_csv("/home/piotr/Programowanie/Projekt_twd_2/messenger.csv")
result.to_csv("/home/piotr/Programowanie/Projekt_twd_2/messenger.csv")
