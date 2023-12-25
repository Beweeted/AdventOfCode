lower_num=264793
higher_num=803935

run_layer() {
	local input=$1
	local layers=$2
	
	for i in $(eval echo {${input:(-1)}..9}) ; do
		local testing_num=${input}${i}
		#echo "Layers: ${layers} - ${testing_num:layers} -lt ${lower_num:layers}"
		if [ ${testing_num:0:layers} -lt ${lower_num:0:layers} ] ; then continue ; fi
		if [ ${testing_num:0:layers} -gt ${higher_num:0:layers} ] ; then break ; fi
		if [ ${layers} -lt $(( digits - 1 )) ] ; then 
			run_layer ${testing_num} $(( layers + 1 ))
		else
			#test that it has a double
			for i in $(eval echo {0..$(( ${#testing_num} - 2 ))}) ; do
				if [ ${testing_num:i:1} -eq ${testing_num:$((i+1)):1} ] ; then
					simple_matching_numbers=$((simple_matching_numbers+1))
					#echo "Number of matching numbers: ${simple_matching_numbers}.  New success: ${testing_num}"
					break
				fi
			done
			#test for a double that is not a triple
			for i in $(eval echo {0..$(( ${#testing_num} - 2 ))}) ; do
				match=false
				case ${i} in
					0) #if a == b and a != c
						if [[ ${testing_num:i:1} -eq ${testing_num:$((i+1)):1} && ${testing_num:i:1} -ne ${testing_num:$((i+2)):1} ]] ; then match=true ; fi
					;;
					$(( ${#testing_num} - 2 ))) #if a == b and b != c 
						if [[ ${testing_num:i:1} -eq ${testing_num:$((i+1)):1} && ${testing_num:$((i-1)):1} -ne ${testing_num:$((i+1)):1} ]] ; then match=true ; fi
					;;
					*) #if b == c and a != c and b != d
						if [[ ${testing_num:i:1} -eq ${testing_num:$((i+1)):1} && ${testing_num:$((i-1)):1} -ne ${testing_num:$((i+1)):1} && ${testing_num:i:1} -ne ${testing_num:$((i+2)):1} ]] ; then match=true ; fi
					;;
				esac
				
				if [ ${match} == "true" ] ; then
					complex_matching_numbers=$((complex_matching_numbers+1))
					echo "Number of complex matching numbers: ${complex_matching_numbers}.  New success: ${testing_num}"
					break
				fi
			done
		fi
	done
}

digits=${#higher_num}
simple_matching_numbers=0
complex_matching_numbers=0
for a in {0..9} ; do run_layer ${a} 1 ; done
echo ""
echo "Simple: ${simple_matching_numbers}"
echo "Complex: ${complex_matching_numbers}"




