#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

rm log.txt

apply_floating_mask() {
	local v=$1
	local m=$2
	starting_value=$(echo "obase=2;${v}" | bc)
	sv=${starting_value}
	while [ ${#sv} -lt 36 ] ; do
		sv=0${sv}
	done
	starting_value=${sv}

	result_array=()
	for i in {0..35} ; do
		case ${m:i:1} in
			1|X)
				result_array[${i}]=${m:i:1}
				;;
			0)
				result_array[${i}]=${starting_value:i:1}
				;;
		esac
	done

	result_value=$(echo ${result_array[*]} | sed 's/ //g')
	for r in $(eval echo $(echo ${result_value} | sed 's/X/{0,1}/g')) ; do
		echo "ibase=2;${r}" | bc
	done
	#eval echo $(echo ${result_value} | sed 's/X/{0,1}/g') >> log.txt
	#echo "ibase=2;${v}" | bc
	echo "" >&2
}

mem=()
mask=""

echo "Initializing program."
while read line ; do
	if [ ${line:0:4} == "mask" ] ; then
		mask=$(echo ${line} | cut -d' ' -f3)
		echo -n "Processing mask: ${mask}..."
	else
		mem_value=$(echo ${line} | cut -d' ' -f3)
		mem_location=$(echo ${line} | cut -d'[' -f2 | cut -d']' -f1)
		for mem_loc in $(apply_floating_mask "${mem_location}" "${mask}") ; do
			mem[${mem_loc}]=${mem_value}
		done
	fi
done < ${input}

echo ""
echo "Memory: ${mem[*]}"
echo "Memory locations: ${#mem[*]}"
total=0
for m in ${mem[*]} ; do
	((total+=m))
done
echo "Total: ${total}"
