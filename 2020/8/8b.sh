#!/bin/bash
input=input.txt
log=log.txt
branchlog=branchlog.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'


rm ${log} ${branchlog}
have_branched=0
branched_row=1
branched_accum=0
skip_next_branch=0
current_row=1

while true ; do
	echo "${current_row}" >> ${log}
	#If row count is higher than the file length, break
	if [ "${current_row}" -gt $(cat ${input} | wc -l) ] ; then
		echo "End found.  Accumulator value: ${accumulator}."
		break
	fi
	
	#for i in {1..10000} ; do echo -n "" ; done
	duplicate_count=$(egrep -c "^${current_row}$" ${log})
	#echo "Row: ${current_row}.  Have branched: ${have_branched}.  Duplicate count: ${duplicate_count}.  Test results: $([ ${duplicate_count} -gt 0 ])"
	#If the row already exists in the log file, restart from where the branching took place.
	if [[ "${have_branched}" -eq 1 && "${duplicate_count}" -gt 1 ]] ; then
		echo "Repeat detected.  Restarting back to ${branched_row}."
		accumulator=${branched_accum}
		current_row=${branched_row}

		have_branched=0
		branched_row=0
		branched_accum=0
		skip_next_branch=1
		cp ${branchlog} ${log}

	fi

	#echo "Line count: ${current_row}"
	line=$(head -n ${current_row} ${input} | tail -n 1)
	instruction=$(echo ${line} | cut -d' ' -f1)
	count=$(echo ${line} | cut -d' ' -f2)
	echo "${current_row}: ${instruction} - ${count}"
	case ${have_branched} in
		0)
			case ${instruction} in
				nop)
					if [ "${skip_next_branch}" -eq 1 ] ; then
						skip_next_branch=0
					else
						#echo "${current_row}: nop - ${count}"
						branched_row=${current_row}
						have_branched=1
						branched_accum=${accumulator}
						cp ${log} ${branchlog}

						echo "Testing branch.  Row ${current_row}, converting NOP to JMP."

						((current_row+=${count}))
						continue
					fi
					;;
				acc)
					((accumulator+=${count}))
					#echo "${current_row}: acc - ${accumulator}"
					;;
				jmp)
					if [ "${skip_next_branch}" -eq 1 ] ; then
						skip_next_branch=0
						((current_row+=${count}))
						continue
					else
						branched_row=${current_row}
						have_branched=1
						branched_accum=${accumulator}
						cp ${log} ${branchlog}

						echo "Testing branch.  Row ${current_row}, converting JMP to NOP."
						#echo "${current_row}: jmp - ${count}"
					fi
					;;
			esac
			;;
		1)
			case ${instruction} in
				nop)
					#echo "${current_row}: nop - ${count}"
					if [ "${current_row}" -eq "${branched_row}" ] ; then
						((current_row+=${count}))
						continue
					fi
					;;
				acc)
					((accumulator+=${count}))
					#echo "${current_row}: acc - ${accumulator}"
					;;
				jmp)
					#echo "${current_row}: jmp - ${count}"
					if [ "${current_row}" -ne "${branched_row}" ] ; then
						((current_row+=${count}))
						continue
					fi
					;;
			esac
			;;
	esac
	((current_row+=1))
done
