#!/usr/bin/env bash

#test_input="test_"
ticket_input=${test_input}other_tickets.txt
rules_input=${test_input}rules.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

mins=()
maxs=()
while read line ; do
	rule="$(echo ${line} | cut -d':' -f2 | cut -d' ' -f2)"
	mins+=("$(echo ${rule} | cut -d'-' -f1)")
	maxs+=("$(echo ${rule} | cut -d'-' -f2)")
	rule="$(echo ${line} | cut -d':' -f2 | cut -d' ' -f4)"
	mins+=("$(echo ${rule} | cut -d'-' -f1)")
	maxs+=("$(echo ${rule} | cut -d'-' -f2)")
done < ${rules_input}

echo "Rules input:  " $(cat ${rules_input} | wc -l) "lines"
echo "Mins ingested: ${#mins[*]}   Maxs ingested: ${#maxs[*]}"

#echo "Rules:"
#for i in $(eval echo {0..${#mins[*]}}) ; do
#	echo -e "${mins[i]}\t${maxs[i]}"
#done
#echo ""

invalid_sum=0
other_sum=0
row_count=0
total_rows=$(cat ${ticket_input} | wc -l)
while read line ; do
	for v in ${line} ; do
		valid=false
		for r in $(eval echo "{0..${#mins[*]}}") ; do
			if [[ ${v} -ge ${mins[r]} && ${v} -le ${maxs[r]} ]] ; then
				valid=true
				break
			fi
		done
		if [ ${valid} == "false" ] ; then
			#echo "Invalid found: ${v} in line ${row_count}"
			echo "${v} in line ${row_count}"
			((invalid_sum+=v))
		fi
		if [[ ${v} -lt 25 || ${v} -gt 973 ]] ; then
			((other_sum+=v))
		fi
	done
	((row_count+=1))
	#echo -ne "\r${row_count} /" ${total_rows}
done < <(cat ${ticket_input} | sed 's/,/	/g')

echo ""
echo ""
echo "Invalid sum: ${invalid_sum}"
echo "Other sum: ${other_sum}"