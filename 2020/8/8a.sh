#!/bin/bash
input=input.txt
log=log.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

current_row=1
accumulator=0

rm ${log}

while true ; do
	echo "${current_row}" >> ${log}
	if [ "${current_row}" -gt $(cat ${input} | wc -l) ] ; then echo -ne "End:" ; break ; fi
	if [ $(cat ${log} | sort | uniq | wc -l) -ne $(cat ${log} | wc -l) ] ; then echo -ne "Repeat:" ; break ; fi
	line=$(head -n ${current_row} ${input} | tail -n 1)
	instruction=$(echo ${line} | cut -d' ' -f1)
	count=$(echo ${line} | cut -d' ' -f2)
	case ${instruction} in
		nop)
			echo "${current_row}: nop"
			;;
		acc)
			((accumulator+=${count}))
			echo "${current_row}: acc - ${accumulator}"
			;;
		jmp)
			echo "${current_row}: jmp - ${count}"
			((current_row+=${count}))
			continue
			;;
	esac
	((current_row+=1))
done
echo "${accumulator}"
