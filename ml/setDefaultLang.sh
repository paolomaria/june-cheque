#!/bin/bash
#set -e

# sets the following env variables:
#	SHELL_LAGUAGE
#	SHELL_MAIN_LAGUAGE
#	JUNE_CHEQUE_LANG
#	JUNE_CHEQUE_MAIN_LANG

if [ -n "$LANGUAGE" ]; then
	LANGUAGE=$LANG
fi

SHELL_LAGUAGE=$LANGUAGE
SHELL_MAIN_LAGUAGE=`echo $SHELL_LAGUAGE | sed -E 's/^(..).*/\1/g'`

if [ ! -f $MY_PATH/ml/cliText.$SHELL_MAIN_LAGUAGE ]; then
	SHELL_MAIN_LAGUAGE=en
	SHELL_LAGUAGE=en
fi

if [ -z $JUNE_CHEQUE_LANG ]; then
	if [ -f $MY_PATH/ml/chequeText.$SHELL_LAGUAGE ]; then
		JUNE_CHEQUE_LANG=$SHELL_LAGUAGE
	elif [ -f $MY_PATH/ml/chequeText.$SHELL_MAIN_LAGUAGE ]; then
		JUNE_CHEQUE_LANG=$SHELL_MAIN_LAGUAGE
	else
		JUNE_CHEQUE_LANG=fr
	fi
	JUNE_CHEQUE_MAIN_LANG=`echo $JUNE_CHEQUE_LANG | sed -E 's/^(..).*/\1/g'`
else
	JUNE_CHEQUE_MAIN_LANG=`echo $JUNE_CHEQUE_LANG | sed -E 's/^(..).*/\1/g'`
	if [ ! -f $MY_PATH/ml/chequeText.$JUNE_CHEQUE_LANG -a ! -f $MY_PATH/ml/chequeText.$JUNE_CHEQUE_MAIN_LANG ]; then
		echo "The langauge  $JUNE_CHEQUE_LANG is not supported. Using fr"
		JUNE_CHEQUE_LANG=fr
		JUNE_CHEQUE_MAIN_LANG=fr
	fi
fi

