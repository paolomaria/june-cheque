[<img src="https://github.com/paolomaria/june-cheque-app/raw/main/www/img/flag-gb.png">](README.md) [<img src="https://github.com/paolomaria/june-cheque-app/raw/main/www/img/flag-fr.png">](README_fr.md) [<img src="https://github.com/paolomaria/june-cheque-app/raw/main/www/img/flag-de.png">](README_de.md)


![June Cheque logo](https://github.com/paolomaria/june-cheque-app/raw/main/www/img/logo_144px.png)

# june-cheque

Una CLI para crear cheque para la moneda June (ver monnaie-libre.fr). 

## Description

Una de la principales desventajas de June es que se necesita un ordenador o un móvil para realizar una transacción. Esto puede ser un inconveniente para las personas que no tienen móvil.   

Con este CLI se pueden crear June cheques que luego se pueden imprimir en papel y darlo a la persona a la que desea enviar algunos June. Las informaciones de identificación para recibir el pago se escriben en el cheque.

**IMPORTANTE**: ¡¡ esta CLI es todavía experimental. ¡¡Úsela bajo sus propio riesgos !!

## Instalación

 - Descargue e instale el último paquete en://github.com/paolomaria/june-cheque/releases
 ```
wget https://github.com/paolomaria/june-cheque/releases/download/release/2.5/june-cheque.2.5.deb
sudo apt-get install ./june-cheque.2.5.deb
 ```
 
 - Instale silkaj:
 ```
 pip3 install silkaj
 pip3 install aiohttp
 ```
  - Instale jaklis
```
git clone https://github.com/paolomaria/jaklis.git
cd jaklis
bash setup.sh
```
 - Use el june-cheque-create programa:
```
june-cheque-create -h
```

Si quiere crear 10 cheques de 5 June cada uno, llame:
```
june-cheque-create -n 10 -a 5
```

## Ideas

 - crear un pdf en lugar de un archivo txt
 
 
## Donaciones

Todas las donaciones son bienvenidas. Puede transferir algunos June a la siguiente clave pública: `Bv8hAiQAvKWUhRgGtYBzEV2ig8ARqUvXHkD5wq4XrWiN:J1s`

O en un terminal, por ejemplo para transferir 20 June:
```
silkaj money transfer -r "Bv8hAiQAvKWUhRgGtYBzEV2ig8ARqUvXHkD5wq4XrWiN:J1s" -a 20
```
