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

#echo "Test array: 0 3 6 0 3 3 1 0 4 0 "

#cat ${input} | sed 's/,/ /g'

for n in $(cat ${input} | sed 's/,/ /g') ; do
	#echo "Loop: ${loop}  This num: ${n}  Index: ${indexes[n]}"
	next_num=${n}
	if [ "${indexes[n]}" != "" ] ; then
		next_num=$((loop - next_num))
	fi
	indexes[${n}]=${loop}
	#list+=(${next_num})
	((loop+=1))
	last_num=${next_num}
done
#echo "0: ${indexes[0]}   3: ${indexes[3]}  6: ${indexes[6]}"
#echo "Input complete, starting puzzle..."

this_num=0
while [ ${loop} -lt 30000003 ] ; do
	#echo "Loop: ${loop}  This num: ${this_num}  Index: ${indexes[this_num]}"
	next_num=0
	if [ "${indexes[this_num]}" != "" ] ; then
		next_num=$((loop - ${indexes[this_num]}))
	fi
	#list+=(${this_num})
	indexes[${this_num}]=${loop}
	this_num=${next_num}
	#echo -n "${next_num} "
	((loop+=1))
	case ${loop} in
		8)
			#echo ""
			echo "9th loop: ${this_num}"
			#break
			;;
		2019)
			#echo ""
			echo "2020th loop: ${this_num}"
			#break
			;;
		29999999)
			#echo ""
			echo "30000000th loop: ${this_num}"
			;;
	esac
	if [ $((loop % 10000)) -eq 0 ] ; then echo -ne "\r${loop}" ; fi
	#if [ ${loop} -eq 30000 ] ; then break ; fi
done

echo ""
#0 3 6 0 3 3 1 0 4 0 
#echo "${list[*]}"
#echo "${list[3]}"
