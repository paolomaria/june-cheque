[<img src="https://github.com/paolomaria/june-cheque-app/raw/main/www/img/flag-gb.png">](README.md) [<img src="https://github.com/paolomaria/june-cheque-app/raw/main/www/img/flag-es.png">](README_es.md) [<img src="https://github.com/paolomaria/june-cheque-app/raw/main/www/img/flag-fr.png">](README_fr.md)

![June Cheque logo](https://github.com/paolomaria/june-cheque-app/raw/main/www/img/logo_144px.png)

# june-cheque

Eine CLI fuer das Freigeld June (siehe monaie-libre.fr). 

## Beschreibung

Einer der grössten Nachteile von June ist die Tatsache, dass Sie entweder einen Computer oder ein Mobiltelefon benötigen, um eine Transaktion durchzuführen. Dies kann für Personen, die kein Smartphone besitzen, ein Nachteil sein. 

Mit dieser CLI können Sie June-Schecks erstellen, die auf Papier ausgedruckt werden und dann der Person, der Sie June schicken möchten, gegeben werden können. Die für die Auszahlung erforderlichen Identifikationsinformationen werden auf dem Scheck vermerkt.

**WICHTIG**: Diese CLI befindet sich noch im experimentellen Zustand. Die Benutzung erfolgt auf eigene Gefahr !!

## Installation

 - Laden Sie das neueste Paket über den Link https://github.com/paolomaria/june-cheque/releases herunter und installieren Sie es.
 ```
wget https://github.com/paolomaria/june-cheque/releases/download/release/2.5/june-cheque.2.5.deb
sudo apt-get install ./june-cheque.2.5.deb
 ```
 
 - silkaj installieren:
 ```
 pip3 install silkaj
 ```
  - jaklis installieren (nur, wenn Sie Schecks von Nicht-Mitgliedskonten aus erstellen wollen)
```
git clone https://github.com/paolomaria/jaklis.git
cd jaklis
bash setup.sh
```
 - verwenden sie nun das Programm june-cheque-create:
```
june-cheque-create -h
```

Wenn Sie 10 Schecks zu je 5 June erstellen möchten so rufen Sie folgenden Befehl auf:
```
june-cheque-create -n 10 -a 5
```

## Ideen

 - eine pdf-Datei anstelle einer txt-Datei erstellen
 
 
## Spenden

Jede Spende ist willkommen. Sie können einige June auf das Konto mit dem folgenden öffentlichen Schlüssel überweisen:

Bv8hAiQAvKWUhRgGtYBzEV2ig8ARqUvXHkD5wq4XrWiN:J1s`.

Oder in einem Terminal, z. B. um 20 June zu überweisen:
```
silkaj money transfer -r "Bv8hAiQAvKWUhRgGtYBzEV2ig8ARqUvXHkD5wq4XrWiN:J1s" -a 20
```
