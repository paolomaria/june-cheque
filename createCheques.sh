#!/bin/bash
set -e

MY_PATH=.
MY_BIN_PATH=.
VERSION="__VERSION__"

function show_dep_text {
	echo 'Checking presence of the required shell programs (openssl, python3, srm, silkaj)...'
}

hasJaklis=1

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
    echo 'Notice: jaklis is not present on your system. Cheques can only be issued from member accounts.'
	hasJaklis=0
fi

if [ -z "$JUNE_CHEQUE_HOME" ]; then
JUNE_CHEQUE_HOME=${HOME}/june-cheques
fi

amount=none
number=none
simulate=0
weblink=$JUNE_CHEQUE_WEBLINK
outputDir=$JUNE_CHEQUE_HOME

now=`date +"%d/%m/%Y"`

function show_usage {
  if [ $VERSION != "__VERS""ION__" ]; then
  	echo "$0, version $VERSION"
  fi
  echo "Usage: $0 -n <number of cheques> -a <amount of each cheques> [-s] [ -o <output directory> ] [-c <link to website running cesium or similar>]"
  echo "    -s: simulate only. Don't tranfer any money."
  echo "    -c: default is '$JUNE_CHEQUE_WEBLINK' (env variable JUNE_CHEQUE_WEBLINK)."
  echo "    -o: default is '$JUNE_CHEQUE_HOME' (env variable JUNE_CHEQUE_HOME)."
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
    o)  outputDir=$OPTARG
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

mkdir -p $outputDir

ctr=$$
nowFile=`date +"%Y%m%d%H%M%S"`
outputFile=$outputDir"/cheque_"$nowFile"_"$ctr.txt
while [ -s $outputFile ]; do
	ctr=$(($ctr + 1))
	outputFile=$outputDir"/cheque_"$nowFile"_"$ctr.txt
done

> $outputFile
chmod 600 $outputFile

totalAmount=$(( $amount * $number ))

read -sp 'Secret identifier: ' secretId
echo
read -sp 'Password: ' secretPw
echo

owners_lookup_failed=0
owners_pubkey=`python3 ${MY_BIN_PATH}/create_public_key.py "$secretId" "$secretPw"`
owners_lookup=`silkaj  wot lookup $owners_pubkey` || owners_lookup_failed=1

#echo "$owners_lookup"

if [ $owners_lookup_failed -ne 1 ]; then
	ownersPseudo=`echo "$owners_lookup" | awk -v d="" '{s=(NR==1?s:s d)$0}END{print s}'| awk -F " " '{print $NF}'`
elif [ $hasJaklis -ne 1 ]; then
	echo "No Pseudo found for address $owners_pubkey";
	exit 1;
else
	noProfileFound=0
	pubKeyFile=$(mktemp  /tmp/.XXXXXXXXX)
	chmod 600 $pubKeyFile
	python3 ${MY_BIN_PATH}/save_and_load_private_key_file_pubsec.py  $secretId $secretPw $pubKeyFile
	profile=`jaklis -k $pubKeyFile  get` || noProfileFound=1
	srm $pubKeyFile
	if [ $noProfileFound -ne 0 ]; then
		echo "Neither a Pseudo nor a title found for address $owners_pubkey";
		exit 1;
	fi
	echo $profile | grep '"title"' || noProfileFound=1
	if [ $noProfileFound -ne 0 ]; then
		echo "Neither a Pseudo nor a title found for address $owners_pubkey";
		exit 1;
	fi	
	ownersPseudo=`echo $profile | sed -E "s/.*\"title\": \"([^\"]*).*/\1/g"`
	if [ "$profile" = "$ownersPseudo" ]; then
		echo "Neither a Pseudo nor a title found for address $owners_pubkey";
		exit 1;
	fi
fi


if [ $simulate -ne 1 ]; then
	echo "IMPORTANT: the amount of $totalAmount Junes will be tranfered from the following accout:"
	echo "    Pseudo or Title: $ownersPseudo"
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


name=`openssl rand -base64 4 | sed -e "s@/@a@g" -e "s/\+/z/g" -e "s/=//g" -e "s/^.//g"`

webLinkHintText=""
if [ -n "$weblink" ]; then
	webLinkHintText="(par exemple via le site $weblink) "
fi

for (( i = 0 ; $i < $number; i = $i + 1)) ; do
	if [ $i -gt 0 ]; then
		echo "          ----------" >> $outputFile
		echo >> $outputFile
	fi
	userpass=`openssl rand -base64 11 | sed -e "s@/@a@g" -e "s/\+/z/g" -e "s/=//g" `
	passFormatted=`echo $userpass | sed -E "s/(^.....)/\1-/g" | sed -E "s/(.....$)/-\1/g" `
	
	ctr=$(($ctr + 1))
	identifiant="${name}-$ctr"
	pubkey=`python3 ${MY_BIN_PATH}/create_public_key.py "${identifiant}" "$passFormatted"`
	echo "Émis par $ownersPseudo ($owners_pubkey) le $now" >> $outputFile
	echo "Pour: ___________________________, le __/__/____" >> $outputFile
	echo "  Identifiant secret: ${identifiant}" >> $outputFile
	echo "  Mot de passe: $passFormatted" >> $outputFile
	echo "  (Clé publique: $pubkey)" >> $outputFile
	
	if [ $simulate -ne 1 ]; then
		if [ $hasJaklis -eq 1 ]; then
			pubKeyFile=$(mktemp  /tmp/.XXXXXXXXX)
			chmod 600 $pubKeyFile
			python3 ${MY_BIN_PATH}/save_and_load_private_key_file_pubsec.py  ${identifiant} $passFormatted $pubKeyFile
			jaklis -k $pubKeyFile  set -d "Chèque June émis le $now" -A ${MY_PATH}/images/logo.png
			srm $pubKeyFile
		fi

		tfile=$(mktemp  /tmp/.XXXXXXXXX)
		chmod 600 $tfile
		python3 ${MY_BIN_PATH}/createKeyFile.py "$secretId" "$secretPw" "$tfile"
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


