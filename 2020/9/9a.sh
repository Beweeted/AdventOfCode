#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

batch_size=25
slot=0
queue=()

while read num ; do
	#echo "Queue size: ${#queue[*]}"
	if [ "${#queue[*]}" -lt ${batch_size} ] ; then
		queue[${slot}]=${num}
	else
		has_match=false
		for a in ${queue[*]} ; do
			for b in ${queue[*]} ; do
				if [ ${a} -eq ${b} ] ; then continue ; fi
				if [ $(( a + b )) -eq ${num} ] ; then has_match=true ; fi
				if [ "${has_match}" == "true" ] ; then break ; fi
			done
			if [ "${has_match}" == "true" ] ; then break ; fi
		done
		if [ "${has_match}" == "false" ] ; then echo -e "\nBAD NUMBER: ${num}" ; break ; fi
		echo -ne "."
		queue[${slot}]=${num}
	fi
	((slot+=1))
	if [ ${slot} -ge ${batch_size} ] ; then
		((slot-=${batch_size}))
	fi
done < ${input}


