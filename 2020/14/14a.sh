#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

apply_mask() {
	local v=$1
	local m=$2
	starting_value=$(echo "obase=2;${v}" | bc)
	sv=${starting_value}
	while [ ${#sv} -lt 36 ] ; do
		sv=0${sv}
	done
	starting_value=${sv}

	#echo "Val: ${v}   SV: ${starting_value}" >&2
	result_array=()
	for i in {0..35} ; do
		#echo "Mask: ${m} - M:i: ${m:i:1} - SV:i: ${starting_value:i:1}" >&2
		case ${m:i:1} in
			0|1)
				#echo "M:i: ${m:i:1}" >&2
				result_array[${i}]=${m:i:1}
				;;
			"X")
				result_array[${i}]=${starting_value:i:1}
				;;
		esac
	done
	#echo "RA: ${result_array[*]}" >&2
	result_value=$(echo ${result_array[*]} | sed 's/ //g')
	echo "ibase=2;${result_value}" | bc
}

mem=()
mask=""

echo "Initializing program."
while read line ; do
	if [ ${line:0:4} == "mask" ] ; then
		mask=$(echo ${line} | cut -d' ' -f3)
		echo "Processing mask: ${mask}..."
		#echo -ne "\rProcessing mask: ${mask}..."
	else
		mem_value=$(echo ${line} | cut -d' ' -f3)
		mem_location=$(echo ${line} | cut -d'[' -f2 | cut -d']' -f1)
		mem[${mem_location}]=$(apply_mask "${mem_value}" "${mask}")
		#echo "Value stored: ${mem_value}  At location: ${mem_location}"
	fi
done < ${input}

echo ""
echo "Memory: ${mem[*]}"
total=0
for m in ${mem[*]} ; do
	((total+=m))
done
echo "Total: ${total}"
