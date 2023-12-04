#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

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
	resolve_floating_mask ${result_value}
	echo "" >&2
}
rm log.txt
resolve_floating_mask() {
	local v=$1
	local masked=false
	local i=0

	for i in {0..35} ; do
		if [ ${v:i:1} == "X" ] ; then
			echo -n "." >&2
			#resolve_floating_mask $(echo ${v} | sed 's/^\(.\{'${i}'\}\)./\10/')
			#resolve_floating_mask $(echo ${v} | sed 's/^\(.\{'${i}'\}\)./\11/')
			resolve_floating_mask $(echo ${v:0:i}0${v:$((i+1))})
			resolve_floating_mask $(echo ${v:0:i}1${v:$((i+1))})
			masked=true
			break
		fi
	done
	if [ ${masked} == "false" ] ; then
		echo "ibase=2;${v}" | bc
	fi
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
total=0
for m in ${mem[*]} ; do
	((total+=m))
done
echo "Total: ${total}"
