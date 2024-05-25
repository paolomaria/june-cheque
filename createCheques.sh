#!/bin/bash
set -e

function show_dep_text {
	echo 'Checking presence of the required shell programs (openssl, python3, srm, silkaj)...'
}

addLogo=1

if ! [ -x "$(command -v openssl)" ]; then
	show_dep_text
    echo 'Error: openssl is not present on your system. Please install it and run this script again.'
    exit 1
fi
if ! [ -x "$(command -v python3)" ]; then
	show_dep_text
    echo 'Error: python3 is not present on your system. Please install it and run this script again.'
    exit 1
fi
if ! [ -x "$(command -v srm)" ]; then
	show_dep_text
    echo 'Error: srm is not present on your system. Please install it and run this script again.'
    exit 1
fi
if ! [ -x "$(command -v silkaj)" ]; then
	show_dep_text
    echo 'Error: silkaj is not present on your system. Please install it and run this script again.'
    exit 1
fi
if ! [ -x "$(command -v jaklis)" ]; then
    echo 'Notice: jaklis is not present on your system. No logo will be added to the check account.'
	addLogo=0
fi

amount=none
number=none
simulate=0
outputFile="none"
weblink="none"

now=`date +"%d/%m/%Y"`

function show_usage {
  echo "Usage: createCheques.sh -n <number of cheques> -a <amount of each cheques> [-s] -o <output file> [-c <link to website running cesium or similar>]"
  echo "    -s: simulate only. Don't tranfer any money."
}

while getopts "ha:n:so:c:" opt; do
  case "$opt" in
    h)
	  show_usage
      exit 0
      ;;
    n)  number=$OPTARG
      ;;
    a)  amount=$OPTARG
      ;;
    o)  outputFile=$OPTARG
      ;;
    c)  weblink=$OPTARG
      ;;
    s)  simulate=1
      ;;
  esac
done

if [ $amount == "none" -o $number == "none" ]; then
	show_usage
	exit 1
fi

if [ $outputFile == "none" ]; then
	show_usage
	exit 1
fi

if ! [[ "$amount" =~ ^[1-9][0-9]*$ ]]; then
	echo "Amount must be a positive number"
	exit 1
fi

if ! [[ "$number" =~ ^[1-9][0-9]*$ ]]; then
	echo "Number of cheques must be a positive number"
	exit 1
fi

if [ $amount -gt 100 ]; then
	echo "Amount can be maximal 100"
	exit 1
fi

if [ $number -gt 10 ]; then
	echo "Number of cheques can be maximal 10"
	exit 1
fi

if [ -f $outputFile ]; then
	echo "The file $outputFile already exists"
	exit 1
fi

> $outputFile
chmod 600 $outputFile

totalAmount=$(( $amount * $number ))

read -sp 'Secret identifier: ' secretId
echo
read -sp 'Password: ' secretPw
echo

owners_pubkey=`python3 create_public_key.py "$secretId" "$secretPw"`
owners_lookup=`silkaj  wot lookup $owners_pubkey`

#echo "$owners_lookup"

ownersPseudo=`echo "$owners_lookup" | awk -v d="" '{s=(NR==1?s:s d)$0}END{print s}'| awk -F " " '{print $NF}'`

if [ $simulate -ne 1 ]; then
	echo "IMPORTANT: the amount of $totalAmount Junes will be tranfered from the following accout:"
	echo "    Pseudo: $ownersPseudo"
	echo "    Public Key: $owners_pubkey"
	echo "The secret identifier and password will be stored in the file $outputFile. If you loose this file the money will be lost"
	read -p 'Proceed (Y/N): ' proceed
	echo
	if [ "$proceed" != "Y" ]; then
		echo "Transaction has been stopped by the user"
		rm $outputFile
		exit 1
	fi
fi


name=`echo "${ownersPseudo}_$$"`
name=`openssl rand -hex 2`
ctr=$$

webLinkHintText=""
if [ $weblink != "none" ]; then
	webLinkHintText="(par exemple via le site $weblink) "
fi

for (( i = 0 ; $i < $number; i = $i + 1)) ; do
	if [ $i -gt 0 ]; then
		echo "          ----------" >> $outputFile
		echo >> $outputFile
	fi
	userpass=`openssl rand -base64 6`
	passFormatted=`echo $userpass | sed -E "s/(^....)/\1-/g"`
	
	ctr=$(($ctr + 1))
	identifiant="${name}-$ctr"
	pubkey=`python3 create_public_key.py "${identifiant}" "$passFormatted"`
	echo "Émis par $ownersPseudo ($owners_pubkey) le $now" >> $outputFile
	echo "Pour: ___________________________, le __/__/____" >> $outputFile
	echo "  Identifiant secret: ${identifiant}" >> $outputFile
	echo "  Mot de passe: $passFormatted" >> $outputFile
	echo "  (Clé publique: $pubkey)" >> $outputFile
	
	if [ $simulate -ne 1 ]; then
		if [ $addLogo -eq 1 ]; then
			pubKeyFile=$(mktemp  /tmp/.XXXXXXXXX)
			chmod 600 $pubKeyFile
			python3 save_and_load_private_key_file_pubsec.py  ${identifiant} $passFormatted $pubKeyFile
			jaklis -k $pubKeyFile  set -d "Cheque June émis le $now" -A logo.png
			srm $pubKeyFile
		fi

		tfile=$(mktemp  /tmp/.XXXXXXXXX)
		chmod 600 $tfile
		python3 createKeyFile.py "$secretId" "$secretPw" "$tfile"
		silkaj -af --file "$tfile" money transfer -a $amount -r "$pubkey" -c "cheque  $pubkey" -y
		srm $tfile
		echo "  Valeur: $amount June." >> $outputFile
	else
		echo "  Valeur: sans valeur." >> $outputFile
	fi
	echo "Pour encaisser ce chèque enregistrez-vous$webLinkHintText avec l'identifiant secret et le mot de passe en haut et transférez les $amount June vers votre compte. Une fois transférées, le chèque peut être détruit." >> $outputFile

	echo >> $outputFile
	
done

echo
echo "The file '$outputFile' has been successfully created. It contains the $number cheque(s). Keep this file until the money has been cashed or the money will be lost."


