[<img src="https://github.com/paolomaria/june-cheque-app/raw/main/www/img/flag-gb.png">](README.md) [<img src="https://github.com/paolomaria/june-cheque-app/raw/main/www/img/flag-es.png">](README_es.md)

![June Cheque logo](https://github.com/paolomaria/june-cheque-app/raw/main/www/img/logo_144px.png)

# june-cheque

Une CLI afin de créer un chèque pour la monnaie June (voir monaie-libre.fr). 

## Description

L'un des principaux désavantages de June et le fait qu'il vous faut soit un ordinateur soit un téléphone portable pour réaliser une transaction. Ceci peut être un inconvénient pour les personnes ne possédant pas de smartphone. 

Avec cette CLI vous pouvez créer des chèques June qui pourront être imprimés sur papier et ensuite donnés à la personne à laquelle vous voulez envoyer des June. Les informations d'identification nécessaires pour être payé sont inscrites sur le chèque.

**IMPORTANT**: cette CLI est encore en état expérimental. Utilisez-la à vos risques et périls !!

## Installation

 - Téléchargez et installez le dernier paquet en suivant le lien https://github.com/paolomaria/june-cheque/releases
 ```
wget https://github.com/paolomaria/june-cheque/releases/download/release/2.3/june-cheque.2.3.deb
sudo apt-get install ./june-cheque.2.3.deb
 ```
 
 - installez silkaj:
 ```
 pip3 install silkaj
 ```
  - installez jaklis (seulement si vous voulez créer des chèques à partir de comptes non-membres)
```
git clone https://git.p2p.legal/axiom-team/jaklis.git
cd jaklis
bash setup.sh
```
 - utilisez le june-cheque-create logiciel:
```
june-cheque-create -h
```

Si vous voulez créer 10 chèque de 5 June chacun, appelez:
```
june-cheque-create -n 10 -a 5
```

Actuellement, les chèques sont en français, anglais et espagnol.


## Idées

 - pouvoir créer un pdf au lieu d'un fichier txt
 
 
## Donations

Toutes les donations sont la bienvenue. Vous pouvez transférer quelques June en suivant la clé publique suivante: `Bv8hAiQAvKWUhRgGtYBzEV2ig8ARqUvXHkD5wq4XrWiN:J1s`

Ou dans un terminal, par exemple pour transférer 20 June:
```
silkaj money transfer -r "Bv8hAiQAvKWUhRgGtYBzEV2ig8ARqUvXHkD5wq4XrWiN:J1s" -a 20
```
