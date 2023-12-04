#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

while read line ; do
	unset schedule
	schedule=($(echo ${line} | sed 's/,/ /g'))
	
	big=0
	big_id=0
	i=-1
	for s in ${schedule[*]} ; do
		((i+=1))
		if [ ${s} == "x" ] ; then
			continue
		fi

		if [ ${s} -gt ${big} ] ; then
			big=${s}
			big_id=${i}
		fi
	done
	echo "Biggest: ${big}  ID: ${big_id}"

	echo -n "Searching..."
	loop=1
	while true ; do
		start_time=$(( big * loop - big_id ))
		match=true
		i=-1
		for s in ${schedule[*]} ; do
			((i+=1))
			if [ ${s} == "x" ] ; then
				continue
			fi
			if [ $(( (start_time + i) % ${s} )) -ne 0 ] ; then
				match=false
				break
			fi
		done
		if [ ${match} == "true" ] ; then
			echo -e "\t FINISHED!"
			break
		else
			echo -ne "\rLoop: ${loop}  Start time: ${start_time}"
		fi
		((loop+=1))
	done
done < ${input}

