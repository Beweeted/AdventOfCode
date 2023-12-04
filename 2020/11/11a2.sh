#!/bin/bash
input=test_input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

EMPTY="L"
FULL="#"
AISLE="."

#Instead of counting 8 spaces for each tile, we should just count the whole grid once and increment the spaces around it.
count_neighbours2() {
	echo ""
}

count_neighbours() {
	local in_x=$1
	local in_y=$2

	local n=0
	for y in {-1..1} ; do
		for x in {-1..1} ; do
			if [[ ${x} -eq ${y} && ${x} -eq 0 ]] ; then continue ; fi
			tx=$((in_x+x))
			ty=$((in_y+y))
			if [[ $((in_x+x)) -lt 1 ]] ; then continue ; fi
			if [[ $((in_y+y)) -lt 1 ]] ; then continue ; fi
			if [[ $((in_x+x)) -gt ${max_x} ]] ; then continue ; fi
			if [[ $((in_y+y)) -gt ${max_y} ]] ; then continue ; fi
			if [ "${layout[ty]:tx:1}" == "${FULL}" ] ; then ((n+=1)) ; fi
			#echo "Target: ${tx},${ty}   Result: ${layout[ty]:tx:1}" >&2
		done
	done
	echo ${n}
}

max_x=$(head -n 1 ${input} | wc -c)
max_y=$(cat ${input} | wc -l)

((max_x-=1))
((max_y-=1))

echo "MX: ${max_x}  MY: ${max_y}"

declare -A layout=()

echo -n "Loading file "
for y in $(eval echo "{1..$(( max_y+1))}") ; do
	line=()
	l=$(head -n ${y} ${input} | tail -n 1)
	for x in $(eval echo "{0..$(( ${#l}-1 ))}") ; do
		layout["${x},$((y-1))"]=${l:x:1}
		echo "${x},$((y-1)) - ${l:x:1}"
	done
	#echo -n "."
done
echo -e "\nLoading completed!"

echo "Printing grid:"
for y in $(eval echo "{0..${max_y}}") ; do
	for x in $(eval echo "{0..${max_x}}") ; do
		echo -n "${x},${y} "
		#echo -n ${layout["${x},${y}"]}
	done
	echo ""
done

echo ${layout[*]}

echo "Printing grid:"
for y in $(eval echo "{0..${max_y}}") ; do
	for x in $(eval echo "{0..${max_x}}") ; do
		echo -n ${layout["${x},${y}"]}
	done
	echo ""
done

echo ${layout[*]}

echo ${layout["0,0"]} ${layout["1,0"]} ${layout["2,0"]}
echo ${layout["0,1"]} ${layout["1,1"]} ${layout["2,1"]}
echo ${layout["0,2"]} ${layout["1,2"]} ${layout["2,2"]}

echo "${#layout[@]}"

exit

echo -n "Loading file "
for y in $(eval echo "{1..$(( max_y+1))}") ; do
	line=()
	l=$(head -n ${y} ${input} | tail -n 1)
	for i in $(eval echo "{0..$(( ${#l}-1 ))}") ; do
		line+=(${l:i:1})
	done
	layout[$((y-1))]="${line[*]}"
	echo -n "."
done
echo -e "\nLoading completed!"

echo "Printing grid:"
for y in $(eval echo "{0..${max_y}}") ; do
	line=(${layout[y]})
	for x in $(eval echo "{0..${max_x}}") ; do
		echo -n ${line[x]}
	done
	echo ""
done

neighbours=()
for y in $(eval echo "{0..${max_y}}") ; do
	line=(${layout[y]})
	for x in $(eval echo "{0..${max_x}}") ; do
		echo -n ${line[x]}
	done
	echo ""
done


exit

echo -n "Counting neighbours:"
for y in $(eval echo "{1..${max_y}}") ; do
	echo ""
done
#tput cuu ${max_y}
#tput sc
while true ; do
	neighbours=("asdf")
	results=("asdf")
	out=0
	#tput rc
	#tput ed
	for y in $(eval echo "{1..${max_y}}") ; do
		line="q"
		rline="q"
		for x in $(eval echo "{1..${max_x}}") ; do
			#res=0
			case "${layout[y]:x:1}" in
				"${EMPTY}")
					#Count and update
					res=$(count_neighbours ${x} ${y})
					out="${EMPTY}"
					if [ ${res} -eq 0 ] ; then
						out="${FULL}"
					fi
					;;
				"${FULL}")
					#Count and update
					res=$(count_neighbours ${x} ${y})
					out="${FULL}"
					if [ ${res} -ge 4 ] ; then
						out="${EMPTY}"
					fi
					;;
				"${AISLE}")
					res="${AISLE}"
					out="${AISLE}"
					;;
			esac
			rline+=${res}
			line+=${out}
		done
		#echo "${line:1}"
		#echo -e "${layout[y]:1}\t${rline:1}\t${line:1}"
		results+=(${rline})
		neighbours+=(${line})
		#for i in {0..1000} ; do echo -n "" ; done
	done
	if [ "${layout[*]}" == "${neighbours[*]}" ] ; then
		echo "Stability found, exiting!"
		break
	fi
	#for i in {0..50000} ; do echo -n "" ; done
	layout=(${neighbours[*]})
	echo -n "."
	break
done

echo "Printing grid:"
seat_count=0
for y in $(eval echo "{1..${max_y}}") ; do
	for x in $(eval echo "{1..${max_x}}") ; do
		echo -n ${layout[y]:x:1}
		if [ "${layout[y]:x:1}" == "${FULL}" ] ; then ((seat_count+=1)) ; fi
	done
	echo ""
done


echo "Filled seats: ${seat_count}"