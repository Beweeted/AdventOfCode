#!/bin/bash
input=input.txt
tmp=tmp.txt

red='\e[31m'
green='\e[32m'
white='\e[0m'

max_seat=0

echo -n "" > ${tmp}

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

	#printf "${output}\n"
	echo "${seat_id}" >> ${tmp}

done < ${input}

first=0
last_seat=0
echo "Checking seats..."
while read seat_id ; do
	echo -ne "${seat_id}, "
	if [ "${first}" -eq 0 ] ; then
		last_seat=${seat_id}
		first=1
	else
		if [ ${seat_id} -ne $(( last_seat + 1 )) ] ; then
			echo ""
			echo "NON-CONTINUOUS SEATS FOUND: ${seat_id} + ${last_seat}"
			echo "Suspected empty seat: $(( seat_id - 1))"
			break
		fi
	fi
	last_seat=${seat_id}
done < <(sort -n ${tmp})


