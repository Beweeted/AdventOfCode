OPCODE_SIZE=2
OVERRIDE=override
INTERACTIVE_MODE_INTERACTIVE=interactive #When the user can type commands
INTERACTIVE_MODE_NONINTERACTIVE=noninteractive #When the user can't type commands. Eg: when piping together

LOGGER_MODE_DEBUG=2
LOGGER_MODE_WARNING=1
LOGGER_MODE_ERROR=0

LOG_DEBUG=2
LOG_WARN=1
LOG_ERR=0

#Prints output to stderr if the requested logging level is equal or lower than defined logging level.
#Eg: $(logger ${LOG_WARN} asdf) will write "asdf" to stderr if ${LOGGER_MODE} is LOGGER_MODE_WARNING or LOGGER_MODE_DEBUG,
#  but not if ${LOGGER_MODE} is LOGGER_MODE_ERROR
logger(){
  local logmode=$1
  shift
  local output="${@}"
  if [[ "${logmode}" -le "${LOGGER_MODE}" ]] ; then
    echo "${output}" >&2
  fi
}

print_array(){
	logger ${LOG_WARN} "Array: ${array[*]}"
}

trap print_array EXIT

#Parse through the parameters with the opcode, and return the next parameter
get_next_param(){
	next_param=${params:(-1)}
	if [ $((${#params}-1)) -lt 1 ] ; then
    logger ${LOG_DEBUG} "Size: $((${#params}-1))"
  fi
	params=$(echo ${params} | cut -c1-$((${#params}-1)))
}

get_next_value(){
	logger ${LOG_DEBUG} "Params: ${params}  Next param: ${next_param}"
	if [ "${1}" == "${OVERRIDE}" ] ; then
		logger ${LOG_DEBUG} "Overriding next param: must be immediate."
		next_param=1
	fi
	case "${next_param}" in
	  0) #position mode
			next_value=${array[${array[arrayindex]}]}
			logger ${LOG_DEBUG} "Getting positional.  Index: ${array[arrayindex]}  Value: ${next_value}"
			arrayindex=$((arrayindex+1))
	  ;;
	  1) #immediate mode
			next_value=${array[arrayindex]}
			logger ${LOG_DEBUG} "Getting immediate.  Value: ${array[arrayindex]}"
			arrayindex=$((arrayindex+1))
	  ;;
    2) #relative mode
      next_index=$((relativeindex + ${array[arrayindex]}))
      next_value=${array[next_index]}
      logger ${LOG_DEBUG} "Getting relative.  Index: ${arrayindex}  Relative: ${relativeindex}  Value: ${next_value}"
      arrayindex=$((arrayindex+1))
    ;;
	  *)
			logger ${LOG_ERR} "Unrecognized parameter: ${param}"
			exit
	  ;;
	esac
  if [ "${next_value}" == "" ] ; then
    logger ${LOG_WARN} "WARNING: memory location out of range.  Returning 0 instead."
    next_value=0
  fi
	get_next_param
}

run_script(){
	logger ${LOG_WARN} "Starting array: ${array[*]}"
	logger ${LOG_DEBUG} ""
	arrayindex=0
  relativeindex=0
	param=0
	while true ; do
	  logger ${LOG_DEBUG} "Indexer: ${arrayindex}"

		opblock=000000${array[arrayindex]}
		arrayindex=$((arrayindex+1))

		logger ${LOG_DEBUG} "Opblock: ${opblock}"
		logger ${LOG_DEBUG} ""

		op=$(echo ${opblock} | cut -c$((${#opblock}-${OPCODE_SIZE}+1))-${#opblock})
		params=0$(echo ${opblock} | cut -c1-$((${#opblock}-${OPCODE_SIZE})))

	  get_next_param

		logger ${LOG_DEBUG} "Op: ${op}  Params: ${params}  First param: ${next_param}"
		logger ${LOG_DEBUG} "Next values: ${array[*]:${arrayindex}:4}"

  	case ${op} in
	    1|01) #addition
				get_next_value
				num1=${next_value}
				get_next_value
				num2=${next_value}
				get_next_value ${OVERRIDE}
				dest=${next_value}

	      result=$(( ${num1} + ${num2} ))
	      logger ${LOG_WARN} "Adding.  ${num1} + ${num2} = ${result}.  Destination: ${dest}"
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
	      logger ${LOG_WARN} "Multiplying.  ${num1} * ${num2} = ${result}.  Destination: ${dest}"
	      array[${dest}]=${result}
	    ;;
	  	3|03) #input
				get_next_value ${OVERRIDE}
				dest=${next_value}
				case ${INTERACTIVE_MODE} in
					${INTERACTIVE_MODE_INTERACTIVE})
						echo -n "Please provide input: "
						read input
					;;
					${INTERACTIVE_MODE_NONINTERACTIVE})
						input=$1
						shift
						if [ "${input}" == "" ] ; then logger ${LOG_ERR} "ERROR: MISSING INPUT!" ; fi
					;;
				esac
				logger ${LOG_WARN} "Inputting.  Destination: ${dest}  Value: ${input}"
				array[${dest}]=${input}
		  ;;
		  4|04) #output
				get_next_value ${OVERRIDE}
				value=${next_value}
				logger ${LOG_WARN} "Outputting.  Value: ${value}"
				echo ${value}
		  ;;
		  5|05) #jump-if-true
				get_next_value
				true_check=${next_value}
				get_next_value
				if [ ${true_check} -ne 0 ] ; then
					arrayindex=${next_value}
					logger ${LOG_WARN} "Jumping if not zero.  Testing ${true_check}.  True!  Jumping to index: ${next_value}"
				else
					logger ${LOG_WARN} "Jumping if not zero.  Testing ${true_check}.  False!  Not jumping."
				fi
	  	;;
	  	6|06) #jump-if-false
				get_next_value
				true_check=${next_value}
				get_next_value
				if [ ${true_check} -eq 0 ] ; then
					arrayindex=${next_value}
					logger ${LOG_WARN} "Jumping if zero.  Testing ${true_check}.  True!  Jumping to index: ${next_value}"
				else
					logger ${LOG_WARN} "Jumping if zero.  Testing ${true_check}.  False!  Not jumping."
				fi
	  	;;
	  	7|07) #less than
				get_next_value
				num1=${next_value}
				get_next_value
				num2=${next_value}
				get_next_value ${OVERRIDE}
				dest=${next_value}

				echo -n "" >&2
				if [ ${num1} -lt ${num2} ] ; then
					result=1
					logger ${LOG_WARN} "Storing if less.  Less!  Storing 1 at ${dest}"
				else
					result=0
					logger ${LOG_WARN} "Storing if less.  Not less!  Storing 0 at ${dest}"
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

				if [ ${num1} -eq ${num2} ] ; then
					result=1
					logger ${LOG_WARN} "Storing if equal.  Equal!  Storing 1 at ${dest}"
				else
					result=0
					logger ${LOG_WARN} "Storing if equal.  Not equal!  Storing 0 at ${dest}"
				fi
				array[${dest}]=${result}
	  	;;
      9|09) #move relativeindex pointer
        logger ${LOG_DEBUG} "Unsetting next_value.  Current value: ${next_value}"
        unset next_value
        get_next_value
        num1=${next_value}
        logger ${LOG_DEBUG} "Next value: ${next_value}"
        oldindex=${relativeindex}
        relativeindex=$(( relativeindex + ${num1} ))
        logger ${LOG_WARN} "Moving relative pointer.  Old location: ${oldindex}  New location: ${relativeindex}"
      ;;
	    99) #halt
	      logger ${LOG_WARN} "Halting."
	      exit
	    ;;
	    *) #Error/unknown
	      logger ${LOG_ERR} "ERROR: operator unknown"
				logger ${LOG_ERR} "Indexer: ${arrayindex}"
				logger ${LOG_ERR} "Indexed value: ${array[arrayindex]}"
	      exit
	    ;;
  	esac

  logger ${LOG_DEBUG} ""
  logger ${LOG_DEBUG} ""
  logger ${LOG_WARN} ""
  read junk
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

main() {
	input_file=$1
  load_array_params ${input_file}
	run_script
	logger ${LOG_WARN} ""
}

INTERACTIVE_MODE=${INTERACTIVE_MODE_INTERACTIVE}
LOGGER_MODE=${LOGGER_MODE_DEBUG}
TESTMODE=TEST

if [ ${TESTMODE} == "TEST" ] ; then
  #Test 1
  echo "Test 1: "
  #result=($(main testa1.txt))
  echo "Expected result: produces a copy of itself as output.  Result: ${result[*]}"
  unset result

  read junk

  #Test 2
  echo "Test 2: "
  result=$(main testa2.txt)
  echo "Expected result: a 16-digit number.  Result: ${result}   Length: ${#result}"

  read junk

  #Test 3
  echo "Test 3: "
  #result=$(main testa3.txt)
  echo "Expected result: 1125899906842624.  Result: ${result}"
else
  echo "Main execution: "
  main input.txt
  echo "Main execution complete!"
fi
