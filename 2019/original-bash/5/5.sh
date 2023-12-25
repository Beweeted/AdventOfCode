OPCODE_SIZE=2
OVERRIDE=blkajsdklfja

print_array(){
echo "Array: ${array[*]}"
}

trap print_array EXIT

#Parse through the parameters with the opcode, and return the next parameter
get_next_param(){
#echo "Upcomming params: ${params}  First param: ${params:(-1)}"
next_param=${params:(-1)}
params=${params:0:-1}
#echo "Remaining params: ${params}   This Param:  ${next_param}"
}

get_next_value(){
#echo "Params: ${params}  Next param: ${next_param}"
if [ "${1}" == "${OVERRIDE}" ] ; then
	echo "Overriding next param: must be immediate."
	next_param=1
fi
case "${next_param}" in
  0) #position mode
	next_value=${array[${array[arrayindex]}]}
	echo "Getting positional.  Index: ${array[arrayindex]}  Value: ${next_value}"
	arrayindex=$((arrayindex+1))
  ;;
  1) #immediate mode
	next_value=${array[arrayindex]}
	echo "Getting immediate.  Value: ${array[arrayindex]}"
	arrayindex=$((arrayindex+1))
  ;;
  *)
	echo "Unrecognized parameter: ${param}" >&2
	exit
  ;;
esac
get_next_param
}

get_next_input(){
local val=${inputs[0]}
inputs=("${inputs:1}")
if [ "${val}" == "" ] ; then
	next_input=""
else
	next_input=${val}
fi
shift
}

run_script(){
echo "Starting array: ${array[*]}"
echo ""
arrayindex=0
param=0
echo "Inputs: ${inputs[*]}"
while true ; do
    echo "Indexer: ${arrayindex}"
	
	opblock=000${array[arrayindex]}
	arrayindex=$((arrayindex+1))

	echo "Opblock: ${opblock}"
	echo ""
	
	op=${opblock:(-${OPCODE_SIZE})}
    params=00${opblock:0:(-${OPCODE_SIZE})}
	get_next_param
	
	echo "Op: ${op}  Params: ${params}  First param: ${next_param}"
	echo "Next values: ${array[*]:${arrayindex}:3}"
	
    case ${op} in
      1|01) #addition
		get_next_value
		num1=${next_value}
		get_next_value
		num2=${next_value}
		get_next_value ${OVERRIDE}
		dest=${next_value}
	  
        result=$(( ${num1} + ${num2} ))
        echo "Adding.  ${num1} + ${num2} = ${result}.  Destination: ${dest}"
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
        echo "Multiplying.  ${num1} * ${num2} = ${result}.  Destination: ${dest}"
        array[${dest}]=${result}
      ;;
	  3|03) #input
		get_next_value ${OVERRIDE}
		dest=${next_value}
		read -p "Please provide input: " input
		echo "Inputting.  Destination: ${dest}  Value: ${input}"
		array[${dest}]=${input}
	  ;;
	  4|04) #output
		get_next_value ${OVERRIDE}
		source=${next_value}
		echo "Outputting.  Source: ${source}  Value: ${array[source]}"
	  ;;
	  5|05) #jump-if-true
		get_next_value
		true_check=${next_value}
		get_next_value
		echo -n "Jumping if true.  "
		if [ ${true_check} -ne 0 ] ; then
			arrayindex=${next_value}
			echo "True!  Jumping to index: ${next_value}"
		else
			echo "False!  Not jumping."
		fi
	  ;;
	  6|06) #jump-if-false
		get_next_value
		true_check=${next_value}
		get_next_value
		echo -n "Jumping if false.  "
		if [ ${true_check} -eq 0 ] ; then
			arrayindex=${next_value}
			echo "False!  Jumping to index: ${next_value}"
		else
			echo "True!  Not jumping."
		fi
	  ;;
	  7|07) #less than
		get_next_value
		num1=${next_value}
		get_next_value
		num2=${next_value}
		get_next_value ${OVERRIDE}
		dest=${next_value}
		
		echo -n "Storing if less.  "
		if [ ${num1} -lt ${num2} ] ; then
			result=1
			echo "Less!  Storing 1 at ${dest}"
		else
			result=0
			echo "Not less!  Storing 0 at ${dest}"
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
		
		echo -n "Storing if equal.  "
		if [ ${num1} -eq ${num2} ] ; then
			result=1
			echo "Equal!  Storing 1 at ${dest}"
		else
			result=0
			echo "Not equal!  Storing 0 at ${dest}"
		fi
		array[${dest}]=${result}
	  ;;
      99) #halt
        echo "Halting."
        exit
      ;;
      *) #Error/unknown
        echo "ERROR: operator unknown" >&2
		echo "Indexer: ${arrayindex}" >&2
		echo "Indexed value: ${array[arrayindex]}" >&2
        exit
      ;;
    esac

    echo ""
    echo ""
    echo ""
done
}

load_array_params(){
loop=0
unset array
for a in $(sed 's/,/\n/g' input.txt); do
    array[${loop}]=${a}
    let loop=${loop}+1
done
}

inputs=(${@})
load_array_params
run_script
