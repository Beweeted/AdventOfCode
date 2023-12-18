#!/bin/bash
input=input_2a.txt
validcount=0

while read countrange character password ; do
	mincount=$(echo ${countrange} | cut -d'-' -f1)
	maxcount=$(echo ${countrange} | cut -d'-' -f2)
	char=$(echo ${character} | cut -d':' -f1)
	len=$(( ${#password} - 1 ))
	count=0
	for a in $(eval echo "{0..${len}}") ; do
		if [ "${password:${a}:1}" == "${char}" ] ; then 
			((count+=1))
			echo "Ding!"
		fi
	done
	if [[ ${count} -ge ${mincount} && ${count} -le ${maxcount} ]] ; then
		((validcount+=1))
		echo "Valid password: ${countrange} ${character} ${password}"
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
