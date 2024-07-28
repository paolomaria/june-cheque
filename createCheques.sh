#!/bin/bash
set -e

MY_PATH=.
MY_BIN_PATH=.
VERSION="__VERSION__"

source $MY_PATH/ml/setDefaultLang.sh
source $MY_PATH/ml/cliText.${SHELL_MAIN_LAGUAGE}

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

hasJaklis=1

if ! [ -x "$(command -v openssl)" ]; then
	show_dep_text
	printf "$CLI_NO_SW_INSTALLED_ERROR\n" "openssl"
    exit 1
fi
if ! [ -x "$(command -v python3)" ]; then
	show_dep_text
	printf "$CLI_NO_SW_INSTALLED_ERROR\n" "python3"
    exit 1
fi
if ! [ -x "$(command -v srm)" ]; then
	show_dep_text
	printf "$CLI_NO_SW_INSTALLED_ERROR\n" "srm"
    exit 1
fi
if ! [ -x "$(command -v silkaj)" ]; then
	show_dep_text
	printf "$CLI_NO_SW_INSTALLED_ERROR\n" "silkaj"
    exit 1
fi
if ! [ -x "$(command -v jaklis)" ]; then
    echo "${CLI_NO_JAKLIS_NOTICE}."
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
	echo "$CLI_ERROR_AMOUNT_NOT_POSITIVE"
	exit 1
fi

if ! [[ "$number" =~ ^[1-9][0-9]*$ ]]; then
	echo "$CLI_ERROR_NUMBER_OF_CH_NOT_POSITIVE"
	exit 1
fi

if [ $amount -gt 100 ]; then
	printf "$CLI_ERROR_AMOUNT_MAX\n" 100
	exit 1
fi

if [ $number -gt 10 ]; then
	printf "$CLI_ERROR_NUMBER_OF_CH_MAX\n" 10
	exit 1
fi

mkdir -p $outputDir

ctr=$$
nowFile=`date +"%Y%m%d%H%M%S"`
if [ $simulate -ne 1 ]; then
	filePrefix="cheque"
else
	filePrefix="simulation"
fi

outputFile=$outputDir"/"$filePrefix"_"$nowFile"_"$ctr.txt
while [ -s $outputFile ]; do
	ctr=$(($ctr + 1))
	outputFile=$outputDir"/"$filePrefix"_"$nowFile"_"$ctr.txt
done

> $outputFile
chmod 600 $outputFile

totalAmount=$(( $amount * $number ))

read -sp "$CLI_SECRET_ID: " secretId
echo
read -sp "$CLI_SECRET_PW: " secretPw
echo

owners_lookup_failed=0
owners_pubkey=`python3 ${MY_BIN_PATH}/create_public_key.py "$secretId" "$secretPw"`
owners_lookup=`silkaj  wot lookup $owners_pubkey` || owners_lookup_failed=1

#echo "$owners_lookup"

if [ $owners_lookup_failed -ne 1 ]; then
	ownersPseudo=`echo "$owners_lookup" | awk -v d="" '{s=(NR==1?s:s d)$0}END{print s}'| awk -F " " '{print $NF}'`
elif [ $hasJaklis -ne 1 ]; then
	printf "$CLI_NO_PSEUDO_FOUND\n" "$owners_pubkey"
	exit 1;
else
	noProfileFound=0
	pubKeyFile=$(mktemp  /tmp/.XXXXXXXXX)
	chmod 600 $pubKeyFile
	python3 ${MY_BIN_PATH}/save_and_load_private_key_file_pubsec.py  $secretId $secretPw $pubKeyFile
	profile=`jaklis -k $pubKeyFile  get` || noProfileFound=1
	srm $pubKeyFile
	if [ $noProfileFound -ne 0 ]; then
		printf "$CLI_NO_PSEUDO_NOR_TITLE_FOUND\n" "$owners_pubkey"
		exit 1;
	fi
	echo $profile | grep '"title"' || noProfileFound=1
	if [ $noProfileFound -ne 0 ]; then
		printf "$CLI_NO_PSEUDO_NOR_TITLE_FOUND\n" "$owners_pubkey"
		exit 1;
	fi	
	ownersPseudo=`echo $profile | sed -E "s/.*\"title\": \"([^\"]*).*/\1/g"`
	if [ "$profile" = "$ownersPseudo" ]; then
		printf "$CLI_NO_PSEUDO_NOR_TITLE_FOUND\n" "$owners_pubkey"
		exit 1;
	fi
fi


if [ $simulate -ne 1 ]; then
	printf "$CLI_TRANSFER_COMFIRM_LINE_1\n" $totalAmount
	printf "    $CLI_TRANSFER_COMFIRM_LINE_2\n" "$ownersPseudo"
	printf "    $CLI_TRANSFER_COMFIRM_LINE_3\n" "$owners_pubkey"
	printf "$CLI_TRANSFER_COMFIRM_LINE_4\n" "$outputFile"
	PROCEED_TEXT=`printf "$CLI_TRANSFER_PROCEED" "$CLI_TRANSFER_PROCEED_YES" "$CLI_TRANSFER_PROCEED_NO"`
	read -p "$PROCEED_TEXT: " proceed
	echo
	if [ "$proceed" != "$CLI_TRANSFER_PROCEED_YES" ]; then
		echo "$CLI_TRANSFER_STOPPED_BY_USER"
		rm $outputFile
		exit 1
	fi
fi

receivers=""

name=`openssl rand -base64 4 | sed -e "s@/@a@g" -e "s/\+/z/g" -e "s/=//g" -e "s/^.//g"`

webLinkHintText=" "
if [ -n "$weblink" ]; then
	webLinkHintText=`printf "$WEBLINK_TEXT" "$weblink"`
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
	echo "$ISSUED_BY_TXT $ownersPseudo ($owners_pubkey) $ISSUED_THE_TXT $now" >> $outputFile
	echo "$ISSUED_FOR_TXT: ___________________________, $ISSUED_THE_TXT __/__/____" >> $outputFile
	echo "  $SECRET_ID_TXT: ${identifiant}" >> $outputFile
	echo "  $SECRET_PASS_TXT: $passFormatted" >> $outputFile
	echo "  ($PUBLIC_KEY_TXT: $pubkey)" >> $outputFile
	
	if [ $simulate -ne 1 ]; then
		if [ $hasJaklis -eq 1 ]; then
			pubKeyFile=$(mktemp  /tmp/.XXXXXXXXX)
			chmod 600 $pubKeyFile
			python3 ${MY_BIN_PATH}/save_and_load_private_key_file_pubsec.py  ${identifiant} $passFormatted $pubKeyFile
			chequeTextComment=`printf "$CHEQUE_TEXT_COMMENT" "$now"`
			jaklis -k $pubKeyFile  set -d "$chequeTextComment" -A ${MY_PATH}/images/logo.png
			srm $pubKeyFile
		fi

		receivers="$receivers -r $pubkey"
		echo "  $VALUE_TXT: __000__ June." >> $outputFile
	else
		echo "  $VALUE_TXT: $NO_VALUE_TXT." >> $outputFile
	fi
	printf "$FINAL_CHEQUE_TXT\n" "$webLinkHintText" $amount >> $outputFile

	echo >> $outputFile
	
done

if [ $simulate -ne 1 ]; then
	tfile=$(mktemp  /tmp/.XXXXXXXXX)
	chmod 600 $tfile
	python3 ${MY_BIN_PATH}/createKeyFile.py "$secretId" "$secretPw" "$tfile"
	silkaj -af --file "$tfile" money transfer -a $amount $receivers -c "$CLI_CHECKBOOK" -y
	srm $tfile
	touch $outputFile.tmp
	chmod 600 $outputFile.tmp
	cat $outputFile | sed -e "s/__000__/$amount/g" > $outputFile.tmp
	mv $outputFile.tmp $outputFile
fi

echo
printf "$CLI_TRANSFER_FINISHED\n" "$outputFile" $number


