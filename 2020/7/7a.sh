#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

baglist=baglist.txt
#   rm -f ${baglist}
#   
#   get_containing_bags() {
#   	local bag=$1
#   	local bag_layers=0
#   	echo "Current bag: ${bag}" >&2
#   	local id=0
#   	while read line ; do
#   		((id+=1))
#   		local new_bag=$(echo ${line} | cut -d' ' -f1-2)
#   		get_containing_bags "${new_bag}"
#   		echo "${new_bag}" >> ${baglist}
#   		#echo "Added new bag: ${new_bag}" >&2
#   	done < <(grep "${bag}" ${input} | egrep -v "^${bag}")
#   	#for i in {0..10000} ; do echo -ne "" ; done
#   	echo "Loop done" >&2
#   }
#   
#   #get_containing_bags "shiny gold bags"
#   get_containing_bags "shiny gold"
#   
#   bag_count=$(cat ${baglist} | sort | uniq | wc -l)
#   
#   echo "This many bags found: $(cat ${baglist} | wc -l)"
#   echo "This many container bags: ${bag_count}"


bagin=baglist.txt
bagout=baglist2.txt
echo "shiny gold" > ${bagin}

while true ; do
	row_count=$(cat ${bagin} | wc -l)
	echo "Rows: ${row_count}" >&2
	#cat ${bagin} >&2
	while read line ; do
		echo "${line}" >> ${bagout}
		grep "${line}" ${input} | egrep -v "^${line}" | cut -d' ' -f1-2 >> ${bagout}
	done < ${bagin}
	cat ${bagout} | sort | uniq > ${bagin}
	rm ${bagout}
	if [ $(cat ${bagin} | wc -l) -eq "${row_count}" ] ; then echo "Breaking..." >&2 ; break ; fi
done

echo "This many container bags: $(( row_count - 1 ))"

