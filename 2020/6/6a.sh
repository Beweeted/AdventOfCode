#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
white='\e[0m'

final_total=0

answers=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
while read line ; do
	if [ "${line}" == "" ] ; then
		#end group
		total=0
		for a in ${answers[*]} ; do
			if [ ${a} -eq 1 ] ; then
				((total+=1))
			fi
		done
		((final_total+=total))
		output="Final total:\t${final_total}\tGroup total: ${total}\t- "
		for a in ${answers[*]} ; do
			if [ "${a}" -eq 0 ] ; then
				output+="${red}${a}${white} "
			else
				output+="${green}${a}${white} "
			fi
		done
		printf "${output}\n"
		answers=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
	else
		for i in {0..25} ; do
			if [ ${i} -ge ${#line} ] ; then
				break
			fi
			#echo -ne "${line:i:1} - "
			#printf '%d' "'${line:i:1}"
			answer=$(( $(printf '%d' "'${line:i:1}") - 97 ))
			#echo " - ${answer}"
			answers[${answer}]=1
		done
	fi
done < ${input}

echo "Final total: ${final_total}"
