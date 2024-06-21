![June Cheque logo](https://github.com/paolomaria/june-cheque-app/raw/main/www/img/logo_144px.png)

# june-cheque

A CLI in order to create cheque for the June currency (see monnaie-libre.fr).

## Description

One of the main disadvantage of the June is the fact that you need either a computer or a smartphone in order to execute a transaction. This may be inconvenient for people which do not have a smartphone.

With this CLI you can create June cheques which then can be printed out as paper and given to the person who you want to send some June. The credentials in order to get paid are written on the cheque.

**IMPORTANT**: this CLI is still experimental. Use it at your own risk !!

## Prerequisites

The packages which provide the following binaries have to be installed:

 - openssl (`sudo apt-get install openssl`)
 - python3 (`sudo apt-get install python3`)
 - srm (`sudo apt-get install secure-delete`)
 - silkaj (`pip3 install silkaj`)
 - ([jaklis](https://git.p2p.legal/axiom-team/jaklis))
	 + is only needed if you want to create cheques via a non member account.
 
## How to use

Once you did checkout the project go to the june-cheque directory and all `./createCheques.sh`:
```
cd june-cheque
./createCheques.sh
```
A usage message will appear:
```
Usage: createCheques.sh -n <number of cheques> -a <amount of each cheques> [-s] -o <output file>
    -s: simulate only. Don't tranfer any money.
```

If you want to create 10 cheques of 5 June each, just call:
```
createCheques.sh -n 10 -a 5 -o myFirstCheque.txt
```

The cheques are currently in french.

## Ideas

 - multi language support
 - create a pdf instead of a txt file
 
 
## Donations

Every donation is very welcome. You can transfer some Junes to the following public key: `Bv8hAiQAvKWUhRgGtYBzEV2ig8ARqUvXHkD5wq4XrWiN:J1s`

Or in a shell, for example in order to transfer 20 June:
```
silkaj money transfer -r "Bv8hAiQAvKWUhRgGtYBzEV2ig8ARqUvXHkD5wq4XrWiN:J1s" -a 20
```
