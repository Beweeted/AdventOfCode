#!/bin/bash
input=input.txt

valid_count=0
field_count=0

while read line ; do
	if [ "${line}" == "" ] ; then
		if [[ "${field_count}" -eq 8 || ( "${field_count}" -eq 7 && "${has_cid}" -eq 0 ) ]] ; then
			((valid_count+=1))
		fi
		field_count=0
		has_cid=0
		continue
	fi
	for field in ${line} ; do
		((field_count+=1))
		if [ "${field:0:3}" == "cid" ] ; then has_cid=1 ; fi
	done
done < ${input}
echo "Valid passports: ${valid_count}"
