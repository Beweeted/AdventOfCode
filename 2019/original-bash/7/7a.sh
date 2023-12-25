OPCODE_SIZE=2
OVERRIDE=override
MODE_INTERACTIVE=interactive #When the user can type commands
MODE_NONINTERACTIVE=noninteractive #When the user can't type commands. Eg: when piping together

mode=${MODE_NONINTERACTIVE}

print_array(){
	echo "Array: ${array[*]}" >&2
}

trap print_array EXIT

#Parse through the parameters with the opcode, and return the next parameter
get_next_param(){
	next_param=${params:(-1)}
	if [ $((${#params}-1)) -lt 1 ] ; then echo "Size: $((${#params}-1))" >&2 ; fi
	params=$(echo ${params} | cut -c1-$((${#params}-1)))
}

get_next_value(){
	echo "Params: ${params}  Next param: ${next_param}" >&2
	if [ "${1}" == "${OVERRIDE}" ] ; then
		echo "Overriding next param: must be immediate." >&2
		next_param=1
	fi
	case "${next_param}" in
	  0) #position mode
			next_value=${array[${array[arrayindex]}]}
			echo "Getting positional.  Index: ${array[arrayindex]}  Value: ${next_value}" >&2
			arrayindex=$((arrayindex+1))
	  ;;
	  1) #immediate mode
			next_value=${array[arrayindex]}
			echo "Getting immediate.  Value: ${array[arrayindex]}" >&2
			arrayindex=$((arrayindex+1))
	  ;;
	  *)
			echo "Unrecognized parameter: ${param}" >&2
			exit
	  ;;
	esac
	get_next_param
}

run_script(){
	echo "Starting array: ${array[*]}" >&2
	echo "" >&2
	arrayindex=0
	param=0
	while true ; do
	  echo "Indexer: ${arrayindex}" >&2

		opblock=000000${array[arrayindex]}
		arrayindex=$((arrayindex+1))

		echo "Opblock: ${opblock}" >&2
		echo "" >&2

		op=$(echo ${opblock} | cut -c$((${#opblock}-${OPCODE_SIZE}+1))-${#opblock})
		params=0$(echo ${opblock} | cut -c1-$((${#opblock}-${OPCODE_SIZE})))

	  get_next_param

		echo "Op: ${op}  Params: ${params}  First param: ${next_param}" >&2
		echo "Next values: ${array[*]:${arrayindex}:3}" >&2

  	case ${op} in
	    1|01) #addition
				get_next_value
				num1=${next_value}
				get_next_value
				num2=${next_value}
				get_next_value ${OVERRIDE}
				dest=${next_value}

	      result=$(( ${num1} + ${num2} ))
	      echo "Adding.  ${num1} + ${num2} = ${result}.  Destination: ${dest}" >&2
	      array[${dest}]=${result}
	    ;;
	    2|02) #multiplication
				get_next_value
				num1=${next_value}
				get_next_value
				num2=${next_value}
				get_next_value ${OVERRIDE}
				dest=${next_value}

	      result=$(( ${num1} * ${num2} ))
	      echo "Multiplying.  ${num1} * ${num2} = ${result}.  Destination: ${dest}" >&2
	      array[${dest}]=${result}
	    ;;
	  	3|03) #input
				get_next_value ${OVERRIDE}
				dest=${next_value}
				case ${mode} in
					${MODE_INTERACTIVE})
						echo -n "Please provide input: "
						read input
					;;
					${MODE_NONINTERACTIVE})
						input=$1
						shift
						if [ "${input}" == "" ] ; then echo "ERROR: MISSING INPUT!" ; fi
					;;
				esac
				echo "Inputting.  Destination: ${dest}  Value: ${input}" >&2
				array[${dest}]=${input}
		  ;;
		  4|04) #output
				get_next_value ${OVERRIDE}
				source=${next_value}
				echo "Outputting.  Source: ${source}  Value: ${array[source]}" >&2
				echo ${array[source]}
		  ;;
		  5|05) #jump-if-true
				get_next_value
				true_check=${next_value}
				get_next_value
				echo -n "Jumping if true.  " >&2
				if [ ${true_check} -ne 0 ] ; then
					arrayindex=${next_value}
					echo "True!  Jumping to index: ${next_value}" >&2
				else
					echo "False!  Not jumping." >&2
				fi
	  	;;
	  	6|06) #jump-if-false
				get_next_value
				true_check=${next_value}
				get_next_value
				echo -n "Jumping if false.  " >&2
				if [ ${true_check} -eq 0 ] ; then
					arrayindex=${next_value}
					echo "False!  Jumping to index: ${next_value}" >&2
				else
					echo "True!  Not jumping." >&2
				fi
	  	;;
	  	7|07) #less than
				get_next_value
				num1=${next_value}
				get_next_value
				num2=${next_value}
				get_next_value ${OVERRIDE}
				dest=${next_value}

				echo -n "Storing if less.  " >&2
				if [ ${num1} -lt ${num2} ] ; then
					result=1
					echo "Less!  Storing 1 at ${dest}" >&2
				else
					result=0
					echo "Not less!  Storing 0 at ${dest}" >&2
				fi
				array[${dest}]=${result}
		  ;;
		  8|08) #equals
				get_next_value
				num1=${next_value}
				get_next_value
				num2=${next_value}
				get_next_value ${OVERRIDE}
				dest=${next_value}

				echo -n "Storing if equal.  " >&2
				if [ ${num1} -eq ${num2} ] ; then
					result=1
					echo "Equal!  Storing 1 at ${dest}" >&2
				else
					result=0
					echo "Not equal!  Storing 0 at ${dest}" >&2
				fi
				array[${dest}]=${result}
	  	;;
	    99) #halt
	      echo "Halting." >&2
	      exit
	    ;;
	    *) #Error/unknown
	      echo "ERROR: operator unknown" >&2
				echo "Indexer: ${arrayindex}" >&2
				echo "Indexed value: ${array[arrayindex]}" >&2
	      exit
	    ;;
  	esac

  echo "" >&2
  echo "" >&2
  echo "" >&2
	done
}

load_array_params(){
	local input_file=${1}
	loop=0
	unset array
	for a in $(sed 's/,/ /g' ${input_file}); do
		array[${loop}]=${a}
    let loop=${loop}+1
	done
}

#Main
#INPUT_FILE=input.txt
#phase_sequence=()
#load_array_params
#run_script ${*}

main() {
	input_file=$1
	best_sequence=()
	best_result=0

	for i in {0..4} ; do
		for j in {0..4} ; do
			if [ ${i} == ${j} ] ; then continue ; fi
			for k in {0..4} ; do
				if [[ ${i} == ${k} || ${j} == ${k} ]] ; then continue ; fi
				for l in {0..4} ; do
					if [[ ${i} == ${l} || ${j} == ${l} || ${k} == ${l} ]] ; then continue ; fi
					for m in {0..4} ; do
						if [[ ${i} == ${m} || ${j} == ${m} || ${k} == ${m} || ${l} == ${m} ]] ; then continue ; fi
						phase_sequence=(${i} ${j} ${k} ${l} ${m})
						result=0
						echo -ne "\rTesting sequence: (${phase_sequence[*]})"
						for phase_setting in ${phase_sequence[*]} ; do
							load_array_params ${input_file}
							result=$(run_script ${phase_setting} ${result})
						done
						if [ ${result} -gt ${best_result} ] ; then
							echo "   New best!  Result: ${result}"
							best_result=${result}
						fi
					done
				done
			done
		done
	done
	echo ""
}

echo "Main test: "
main input.txt
echo "Main execution complete!"

asdf() {
#Test 1
echo "Test 1: "
main test1.txt
echo "Expected sequence: (4,3,2,1,0)   Expected value: 43210"

#Test 2
echo "Test 2: "
main test2.txt
echo "Expected sequence: (0,1,2,3,4)   Expected value: 54321"

#Test 3
echo "Test 3: "
main test3.txt
echo "Expected sequence: (1,0,4,3,2)   Expected value: 65210"
}
