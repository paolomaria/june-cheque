for f in /tmp/cheque_*.txt; do
	split -l 10 $f
	for g in x??; do
		SECRET_IDENTIFIER=`cat $g | tail -n+3 | head -1 | sed -E "s/[^:]*: (.*)/\1/g"`
		#echo $SECRET_IDENTIFIER
		SECRET_PW=`cat $g | tail -n+4 | head -1 | sed -E "s/[^:]*: (.*)/\1/g"`
		#echo $SECRET_PW
		python3 createKeyFile.py $SECRET_IDENTIFIER $SECRET_PW /tmp/authfile
		
		silkaj -af --file /tmp/authfile money balance
		PENDING_BALANCE=`silkaj -af --file /tmp/authfile money balance | grep "Pending"`
		TOTAL_BALANCE=`silkaj -af --file /tmp/authfile money balance | grep "Total balance"  |  awk -F '│' '{print $3}' | awk -F ' ' '{print $1}'`
		#BALANCE=`jaklis -k /tmp/authfile balance`
		#echo $PENDING_BALANCE
		echo $TOTAL_BALANCE
		
		if [[ "$PENDING_BALANCE" =~ Pending ]]; then
			echo "NO TRANSFER, something still pending"
		elif [[ "$TOTAL_BALANCE" = "0.0" ]]; then
			echo "NO TRANSFER, no money"
		else
			echo "DOIT"
			silkaj -af --file /tmp/authfile money transfer -a 1 -r AdhCJj8Cz8amRpL57rXpzJmpxyebpYENAyihMyhH1Dhm -c "cashback" -y
			#jaklis -k /tmp/authfile pay -a $BALANCE -p AdhCJj8Cz8amRpL57rXpzJmpxyebpYENAyihMyhH1Dhm -c "cashback"
		fi
		#\rm /tmp/authfile
	done 
done

rm -f x??

rm -f /tmp/cheque_*.txt
