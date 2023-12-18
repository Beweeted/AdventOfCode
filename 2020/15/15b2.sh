#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

list=()
indexes=()
loop=0
last_num=0
next_num=0

for n in $(cat ${input} | sed 's/,/ /g') ; do
	next_num=${n}
	if [ "${indexes[n]}" != "" ] ; then
		next_num=$((loop - next_num))
	fi
	indexes[${n}]=${loop}
	((loop+=1))
	last_num=${next_num}
done

this_num=0
while [ ${loop} -lt 30000003 ] ; do
	#echo "Loop: ${loop}  This num: ${this_num}  Index: ${indexes[this_num]}"
	next_num=0
	indexed=${indexes[this_num]}
	if [ "${indexed}" != "" ] ; then
		next_num=$((loop - indexed))
	fi
	indexes[${this_num}]=${loop}
	this_num=${next_num}
	((loop+=1))
	if [ $((loop % 10000)) -eq 0 ] ; then echo -ne "\r${loop}" ; fi
	#if [ ${loop} -eq 30000 ] ; then break ; fi
	if [ ${loop} -eq 29999999 ] ; then echo "30000000th loop: ${this_num}" ; fi
done

echo ""
