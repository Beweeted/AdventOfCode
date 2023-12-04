#!/bin/bash
input=input_2a.txt
validcount=0

while read countrange character password ; do
	spot_one=$(echo ${countrange} | cut -d'-' -f1)
	spot_two=$(echo ${countrange} | cut -d'-' -f2)
	((spot_one-=1))
	((spot_two-=1))
	char=$(echo ${character} | cut -d':' -f1)
	
	match=false
	if [ "${password:spot_one:1}" == "${char}" ] ; then 
		match=true
		((validcount+=1))
		echo "Ding!"
	fi
	if [ "${password:spot_two:1}" == "${char}" ] ; then 
		echo "Ding!"
		if [ "${match}" == "true" ] ; then
			match=false
			((validcount-=1))
			echo "DOUBLE DING: Setting to false"
		else
			((validcount+=1))
			match=true
		fi
	fi

	if [[ "${match}" == "true" ]] ; then
		echo "Valid password: ${countrange} ${character} ${password}"
		#((validcount+=1))
	else
		echo "Invalid password: ${countrange} ${character} ${password}"
	fi
	#echo ""
	#echo ""
	#echo "mincount: ${mincount}"
	#echo "maxcount: ${maxcount}"
	#echo "char: ${char}"
	#echo "len: ${len}"
	#echo "count: ${count}"
	#echo "validcount: ${validcount}"
	#break
done < $input
echo "Valid password count: ${validcount}"
