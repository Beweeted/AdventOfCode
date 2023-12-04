#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

bad_number=1212510616
#bad_number=127

first_num=0
second_num=0
line_num=500
adding_sum=0
adding_line_num=0
finished=false

line_count=$(cat ${input} | wc -l)

while true ; do
	first_num=$(head -n ${line_num} ${input} | tail -n 1)
	adding_sum=${first_num}
	adding_line_num=${line_num}
	smallest_num=${first_num}
	largest_num=0
	if [ ${line_num} -gt ${line_count} ] ; then echo "How did we get here? -1" ; break ; fi
	if [ ${first_num} -gt ${bad_number} ] ; then echo "How did we get here? -2" ; break ; fi
	while true ; do
		((adding_line_num+=1))
		second_num=$(head -n ${adding_line_num} ${input} | tail -n 1)
		if [ ${second_num} -lt ${smallest_num} ] ; then ((smallest_num=second_num)) ; fi
		if [ ${second_num} -gt ${largest_num} ] ; then ((largest_num=second_num)) ; fi
		((adding_sum+=second_num))
		if [ ${adding_sum} -gt ${bad_number} ] ; then
			echo -ne "."
			break
		fi
		if [ ${adding_sum} -eq ${bad_number} ] ; then
			echo -e "\nNumber found: ${adding_sum}"
			echo "Smallest num: ${first_num}. Largest num: ${largest_num}.  Sum: $(( smallest_num + largest_num))."
			finished=true
			break
		fi
	done
	if [ "${finished}" == "true" ] ; then break ; fi
	((line_num+=1))
done
