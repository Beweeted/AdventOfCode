#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

list=($(cat ${input} | sed 's/,/	/g'))

list_size=${#list[*]}

while [ ${#list[*]} -lt 20 ] ; do
#while [ ${#list[*]} -lt 2025 ] ; do
#while [ ${#list[*]} -lt 30000005 ] ; do
	last_num=${list[$((list_size-1))]}
	next_num=0
	#echo ${list[*]}
	if [[ " ${list[*]} " =~ " ${last_num} " ]] ; then
		for i in $(eval echo "{$((${#list[*]}-2))..0}") ; do
			if [ ${list[i]} -eq ${last_num} ] ; then
				next_num=$((list_size - i - 1))
				#echo "List size: ${list_size}  Index: ${i}  Next num: ${next_num}"
				break
			fi
		done
	fi
	list+=(${next_num})
	list_size=${#list[*]}
	#for i in {0..5000} ; do echo -n "" ; done
	echo -ne "\rList size: ${list_size}"
done

echo ""
echo "0 3 6 0 3 3 1 0 4 0 "
echo "Finished array: ${list[*]}"
echo "List size: ${list_size}"
echo "2020th item: ${list[2019]}"
echo "30000000th item: ${list[29999999]}"

#0 3 6 0 3 3 1 0 4 0 
#0 3 6 0 0 2 0 3 7 0 
