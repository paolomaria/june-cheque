#!/bin/bash
set -e

MY_PATH=.
MY_BIN_PATH=.
VERSION="__VERSION__"

source $MY_PATH/ml/setDefaultLang.sh

if [ -f $MY_PATH/ml/chequeText.$JUNE_CHEQUE_MAIN_LANG ]; then
	source $MY_PATH/ml/chequeText.$JUNE_CHEQUE_MAIN_LANG
else
	echo "Language file $MY_PATH/ml/chequeText.$JUNE_CHEQUE_MAIN_LANG is missing"
	exit 1
fi

if [ -f $MY_PATH/ml/chequeText.$JUNE_CHEQUE_LANG ]; then
	source $MY_PATH/ml/chequeText.$JUNE_CHEQUE_LANG
fi

#echo "NO_VALUE=$NO_VALUE"
#echo "SHELL_LAGUAGE=$SHELL_LAGUAGE"
#echo "SHELL_MAIN_LAGUAGE=$SHELL_MAIN_LAGUAGE"
#echo "JUNE_CHEQUE_LANG=$JUNE_CHEQUE_LANG"
#echo "JUNE_CHEQUE_MAIN_LANG=$JUNE_CHEQUE_MAIN_LANG"

function show_dep_text {
	echo 'Checking presence of the required shell programs (openssl, python3, srm, jaklis)...'
}

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
if ! [ -x "$(command -v jaklis)" ]; then
	show_dep_text
    echo 'Error: jaklis is not present on your system. Please install it and run this script again.'
    exit 1
fi

if [ -z "$JUNE_CHEQUE_HOME" ]; then
JUNE_CHEQUE_HOME=${HOME}/june-cheques
fi

number=none
outputDir=$JUNE_CHEQUE_HOME

now=`date +"%d/%m/%Y"`

function show_usage {
  if [ $VERSION != "__VERS""ION__" ]; then
  	echo "$0, version $VERSION"
  fi
  echo "Usage: $0 -n <number of accounts> [ -o <output directory> ]"
  echo "    -o: default is '$JUNE_CHEQUE_HOME' (env variable JUNE_CHEQUE_HOME)."
  echo "    The language of the account is '$JUNE_CHEQUE_LANG' (env variable JUNE_CHEQUE_LANG)."
}

while getopts "hn:o:" opt; do
  case "$opt" in
    h)
	  show_usage
      exit 0
      ;;
    n)  number=$OPTARG
      ;;
    o)  outputDir=$OPTARG
      ;;
  esac
done

if [ $number == "none" ]; then
	show_usage
	exit 1
fi

if ! [[ "$number" =~ ^[1-9][0-9]*$ ]]; then
	echo "Number of cheques must be a positive number"
	exit 1
fi

if [ $number -gt 10 ]; then
	echo "Number of cheques can be maximal 10"
	exit 1
fi

mkdir -p $outputDir

ctr=$$
nowFile=`date +"%Y%m%d%H%M%S"`

privateOutputFile=$outputDir"/"account_private"_"$nowFile"_"$ctr.txt
publicOutputFile=$outputDir"/"account_public"_"$nowFile"_"$ctr.txt
while [ -s $privateOutputFile -o  -s $publicOutputFile ]; do
	ctr=$(($ctr + 1))
	privateOutputFile=$outputDir"/"account_private"_"$nowFile"_"$ctr.txt
	publicOutputFile=$outputDir"/"account_public"_"$nowFile"_"$ctr.txt
done

> $privateOutputFile
chmod 600 $privateOutputFile

> $publicOutputFile
chmod 600 $publicOutputFile

name=`openssl rand -base64 4 | sed -e "s@/@a@g" -e "s/\+/z/g" -e "s/=//g" -e "s/^.//g"`

webLinkHintText=" "
if [ -n "$weblink" ]; then
	webLinkHintText=`printf "$WEBLINK_TEXT" "$weblink"`
fi

function print_result_and_exit {
	if [ -s $privateOutputFile -a -s $publicOutputFile ]; then
		echo "The files '$privateOutputFile' and '$publicOutputFile' have been successfully created. It contains the $number accounts(s)."
	else
		echo "No account created"
	fi
	exit 1
}

for (( i = 0 ; $i < $number; i = $i + 1)) ; do
	if [ $i -gt 0 ]; then
		echo "          ----------" >> $privateOutputFile
		echo >> $privateOutputFile
		echo "          ----------" >> $publicOutputFile
		echo >> $publicOutputFile
	fi
	pseudo=`openssl rand -base64 4 | sed -e "s@/@a@g" -e "s/\+/z/g" -e "s/=//g" -e "s/^.//g"`
	userpass=`openssl rand -base64 11 | sed -e "s@/@a@g" -e "s/\+/z/g" -e "s/=//g" `
	passFormatted=`echo $userpass | sed -E "s/(^.....)/\1-/g" | sed -E "s/(.....$)/-\1/g" `
	
	ctr=$(($ctr + 1))
	identifiant="${name}-$ctr"

	pubKeyFile=$(mktemp  /tmp/.XXXXXXXXX)
	chmod 600 $pubKeyFile
	python3 ${MY_BIN_PATH}/save_and_load_private_key_file_pubsec.py  ${identifiant} $passFormatted $pubKeyFile
	jaklis -k $pubKeyFile  set -n "$pseudo" -A ${MY_PATH}/images/logo.png || print_result_and_exit
	srm $pubKeyFile

	pubkey=`python3 ${MY_BIN_PATH}/create_public_key.py "${identifiant}" "$passFormatted"`
	echo "$CREATED_THE_TXT $now" >> $privateOutputFile
	echo "$ISSUED_FOR_TXT: ___________________________, $ISSUED_THE_TXT __/__/____" >> $privateOutputFile
	echo "  $SECRET_ID_TXT: ${identifiant}" >> $privateOutputFile
	echo "  $SECRET_PASS_TXT: $passFormatted" >> $privateOutputFile
	echo "  $PSEUDO_TXT: $pseudo" >> $privateOutputFile
	echo "  ($PUBLIC_KEY_TXT: $pubkey)" >> $privateOutputFile
	echo "  $VALUE_TXT: .... June." >> $privateOutputFile
	
	echo "$CREATED_THE_TXT $now" >> $publicOutputFile
	echo "$ISSUED_FOR_TXT: ___________________________, $ISSUED_THE_TXT __/__/____" >> $publicOutputFile
	echo "  $PSEUDO_TXT: $pseudo" >> $publicOutputFile
	echo "  ($PUBLIC_KEY_TXT: $pubkey)" >> $publicOutputFile
	echo "  $TO_PAY_TEXT: .... June." >> $publicOutputFile

	echo >> $publicOutputFile
	echo >> $privateOutputFile
	
done

echo
echo "The files '$privateOutputFile' and '$publicOutputFile' have been successfully created. It contains the $number accounts(s)."


