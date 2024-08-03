[<img src="https://github.com/paolomaria/june-cheque-app/raw/main/www/img/flag-fr.png">](README_fr.md) [<img src="https://github.com/paolomaria/june-cheque-app/raw/main/www/img/flag-es.png">](README_es.md)

![June Cheque logo](https://github.com/paolomaria/june-cheque-app/raw/main/www/img/logo_144px.png)

# june-cheque

A CLI in order to create cheque for the June currency (see monnaie-libre.fr).

## Description

One of the main disadvantage of the June is the fact that you need either a computer or a smartphone in order to execute a transaction. This may be inconvenient for people which do not have a smartphone.

With this CLI you can create June cheques which then can be printed out as paper and given to the person who you want to send some June. The credentials in order to get paid are written on the cheque.

**IMPORTANT**: this CLI is still experimental. Use it at your own risk !!

## Installation for end users

 - Download and install the latest package at https://github.com/paolomaria/june-cheque/releases
 ```
wget https://github.com/paolomaria/june-cheque/releases/download/release/2.5/june-cheque.2.5.deb
sudo apt-get install ./june-cheque.2.5.deb
 ```
 
 - install silkaj:
 ```
 pip3 install silkaj
 ```
  - install jaklis (only if you want to create cheques from non member accounts)
```
git clone https://git.p2p.legal/axiom-team/jaklis.git
cd jaklis
bash setup.sh
```
 - run the june-cheque-create binary:
```
june-cheque-create -h
```

If you want to create 10 cheques of 5 June each, just call:
```
june-cheque-create -n 10 -a 5
```

## Installation for developers

### Prerequisites

The packages which provide the following binaries have to be installed:

 - openssl (`sudo apt-get install openssl`)
 - python3 (`sudo apt-get install python3`)
 - srm (`sudo apt-get install secure-delete`)
 - silkaj (`pip3 install silkaj`)
 - ([jaklis](https://git.p2p.legal/axiom-team/jaklis))
	 + is only needed if you want to create cheques via a non member account.
 
### How to use

Once you did checkout the project go to the june-cheque directory and call `./createCheques.sh`:
```
cd june-cheque
./createCheques.sh
```
A usage message will appear:
```
Usage: ./createCheques.sh -n <number of cheques> -a <amount of each cheques> [-s] [ -o <output directory> ] [-c <link to website running cesium or similar>] 
    -s: simulate only. Don't tranfer any money.
    -c: default is 'https://g-c.li' (env variable JUNE_CHEQUE_WEBLINK).
    -o: default is '/home/user/june-cheques' (env variable JUNE_CHEQUE_HOME).
    The language of the cheques is 'fr' (env variable JUNE_CHEQUE_LANG).
```

If you want to create 10 cheques of 5 June each, just call:
```
createCheques.sh -n 10 -a 5
```

## Ideas

 - multi language support
 - create a pdf instead of a txt file
 
 
## Donations

Every donation is very welcome. You can transfer some Junes to the following public key: `Bv8hAiQAvKWUhRgGtYBzEV2ig8ARqUvXHkD5wq4XrWiN:J1s`

Or in a shell, for example in order to transfer 20 June:
```
silkaj money transfer -r "Bv8hAiQAvKWUhRgGtYBzEV2ig8ARqUvXHkD5wq4XrWiN:J1s" -a 20
```
