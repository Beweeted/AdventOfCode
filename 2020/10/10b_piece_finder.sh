#!/bin/bash
input=test2_input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'


longest=1
last_num=0
current=1
new_line=true
while read j ; do
	joltage_jump=$((j-last_num))
	case ${joltage_jump} in
		1)
			((current+=1))
			;;
		2)
			if [ ${new_line} == "true" ] ; then
				echo -n "${current}"
				new_line=false
			else
				echo -n "-${current}"
			fi
			current=1
			;;
		3)
			if [ ${new_line} == "true" ] ; then
				echo "${current}"
			else
				echo "-${current}"
			fi
			new_line=true
			current=1			
			;;
	esac
	
	last_num=${j}
done < <(sort -n ${input})
echo ${longest}

