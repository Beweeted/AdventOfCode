#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

final_total=0
group_members=0

answers=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
while read line ; do
	if [ "${line}" == "" ] ; then
		#end group
		total=0
		for a in ${answers[*]} ; do
			if [ "${a}" -eq ${group_members} ] ; then
				((total+=1))
			fi
		done
		((final_total+=total))
		output="Final total:\t${final_total}\tGroup total: ${total}\tGroup members: ${group_members}\t- "
		for a in ${answers[*]} ; do
			if [ "${a}" -eq 0 ] ; then
				output+="${red}${a}${white} "
			elif [ "${a}" -lt ${group_members} ] ; then
				output+="${yellow}${a}${white} "
			else
				output+="${green}${a}${white} "
			fi
		done
		printf "${output}\n"
		answers=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		group_members=0
	else
		((group_members+=1))
		for i in {0..25} ; do
			if [ ${i} -ge ${#line} ] ; then
				break
			fi
			#echo -ne "${line:i:1} - "
			#printf '%d' "'${line:i:1}"
			answer=$(( $(printf '%d' "'${line:i:1}") - 97 ))
			#echo " - ${answer}"
			((answers[${answer}]+=1))
		done
	fi
done < ${input}

echo "Final total: ${final_total}"
