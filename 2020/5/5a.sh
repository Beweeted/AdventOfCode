#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
white='\e[0m'

max_seat=0

while read line ; do
	rows=${line:0:7}
	cols=${line: -3}

	min=0
	max=127
	for i in {0..6} ; do
		half_delta=$(( (max - min) / 2 + 1))
		if [ "${rows:i:1}" == "F" ] ; then
			((max -= half_delta))
		else
			((min += half_delta))
		fi
	done
	if [ ${min} -ne ${max} ] ; then
		echo "ROW ERROR!"
	fi
	row=${min}

	min=0
	max=7
	for i in {0..2} ; do
		half_delta=$(( (max - min) / 2 + 1))
		if [ "${cols:i:1}" == "L" ] ; then
			((max -= half_delta))
		else
			((min += half_delta))
		fi
	done
	if [ ${min} -ne ${max} ] ; then
		echo "COL ERROR!"
	fi
	col=${min}

	seat_id=$(( row * 8 + col ))
	output="${line}: ${row} - ${col} - ${seat_id}"

	if [ ${seat_id} -gt ${max_seat} ] ; then
		max_seat=${seat_id}
		output+=" - ${green}NEW MAX!${white}"
	fi
	printf "${output}\n"

done < ${input}

echo "Max seat: ${max_seat}"

