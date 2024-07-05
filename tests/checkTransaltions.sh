#!/bin/bash
set -e


for f in ml/chequeText.??; do
	unset NO_VALUE_TXT
	source $f
	if [ -z "$NO_VALUE_TXT" ]; then
		echo "The transaltion of NO_VALUE_TXT is missing in $f"
		exit 1
	fi
	unset ISSUED_BY_TXT
	source $f
	if [ -z "$ISSUED_BY_TXT" ]; then
		echo "The transaltion of ISSUED_BY_TXT is missing in $f"
		exit 1
	fi
	unset ISSUED_THE_TXT
	source $f
	if [ -z "$ISSUED_THE_TXT" ]; then
		echo "The transaltion of ISSUED_THE_TXT is missing in $f"
		exit 1
	fi
	unset ISSUED_FOR_TXT
	source $f
	if [ -z "$ISSUED_FOR_TXT" ]; then
		echo "The transaltion of ISSUED_FOR_TXT is missing in $f"
		exit 1
	fi
	unset SECRET_ID_TXT
	source $f
	if [ -z "$SECRET_ID_TXT" ]; then
		echo "The transaltion of SECRET_ID_TXT is missing in $f"
		exit 1
	fi
	unset SECRET_PASS_TXT
	source $f
	if [ -z "$SECRET_PASS_TXT" ]; then
		echo "The transaltion of SECRET_PASS_TXT is missing in $f"
		exit 1
	fi
	unset PUBLIC_KEY_TXT
	source $f
	if [ -z "$PUBLIC_KEY_TXT" ]; then
		echo "The transaltion of PUBLIC_KEY_TXT is missing in $f"
		exit 1
	fi
	unset FINAL_CHEQUE_TXT
	source $f
	if [ -z "$FINAL_CHEQUE_TXT" ]; then
		echo "The transaltion of FINAL_CHEQUE_TXT is missing in $f"
		exit 1
	fi
	unset WEBLINK_TEXT
	source $f
	if [ -z "$WEBLINK_TEXT" ]; then
		echo "The transaltion of WEBLINK_TEXT is missing in $f"
		exit 1
	fi
	unset VALUE_TXT
	source $f
	if [ -z "$VALUE_TXT" ]; then
		echo "The transaltion of VALUE_TXT is missing in $f"
		exit 1
	fi
done
