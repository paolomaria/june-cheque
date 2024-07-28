#!/bin/bash
set -e

FILE_TO_CHECK=$1


source $FILE_TO_CHECK
show_dep_text
show_usage

if [ -z "$CLI_NO_SW_INSTALLED_ERROR" ]; then
	echo "The translation of CLI_NO_SW_INSTALLED_ERROR is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_NO_JAKLIS_NOTICE" ]; then
	echo "The translation of CLI_NO_JAKLIS_NOTICE is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_ERROR_AMOUNT_NOT_POSITIVE" ]; then
	echo "The translation of CLI_ERROR_AMOUNT_NOT_POSITIVE is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_ERROR_NUMBER_OF_CH_NOT_POSITIVE" ]; then
	echo "The translation of CLI_ERROR_NUMBER_OF_CH_NOT_POSITIVE is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_ERROR_AMOUNT_MAX" ]; then
	echo "The translation of CLI_ERROR_AMOUNT_MAX is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_ERROR_NUMBER_OF_CH_MAX" ]; then
	echo "The translation of CLI_ERROR_NUMBER_OF_CH_MAX is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_SECRET_ID" ]; then
	echo "The translation of CLI_SECRET_ID is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_SECRET_PW" ]; then
	echo "The translation of CLI_SECRET_PW is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_NO_PSEUDO_FOUND" ]; then
	echo "The translation of CLI_NO_PSEUDO_FOUND is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_NO_PSEUDO_NOR_TITLE_FOUND" ]; then
	echo "The translation of CLI_NO_PSEUDO_NOR_TITLE_FOUND is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_TRANSFER_COMFIRM_LINE_1" ]; then
	echo "The translation of CLI_TRANSFER_COMFIRM_LINE_1 is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_TRANSFER_COMFIRM_LINE_2" ]; then
	echo "The translation of CLI_TRANSFER_COMFIRM_LINE_2 is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_TRANSFER_COMFIRM_LINE_3" ]; then
	echo "The translation of CLI_TRANSFER_COMFIRM_LINE_3 is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_TRANSFER_COMFIRM_LINE_4" ]; then
	echo "The translation of CLI_TRANSFER_COMFIRM_LINE_4 is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_TRANSFER_PROCEED" ]; then
	echo "The translation of CLI_TRANSFER_PROCEED is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_TRANSFER_PROCEED_YES" ]; then
	echo "The translation of CLI_TRANSFER_PROCEED_YES is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_TRANSFER_PROCEED_NO" ]; then
	echo "The translation of CLI_TRANSFER_PROCEED_NO is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_TRANSFER_STOPPED_BY_USER" ]; then
	echo "The translation of CLI_TRANSFER_STOPPED_BY_USER is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_TRANSFER_FINISHED" ]; then
	echo "The translation of CLI_TRANSFER_FINISHED is missing in $FILE_TO_CHECK"
	exit 1
fi

if [ -z "$CLI_CHECKBOOK" ]; then
	echo "The translation of CLI_CHECKBOOK is missing in $FILE_TO_CHECK"
	exit 1
fi

