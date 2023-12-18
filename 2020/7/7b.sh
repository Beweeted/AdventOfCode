#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

get_bag_count() {
	local bag="$1"
	local line=$(egrep "^${bag}" ${input})
	local bagcount=1
	#echo "${line}" >&2
	for loop in {1..4} ; do
		subbag_count=$(echo ${line} | cut -d' ' -f$((4*loop+1)))
		subbag_name=$(echo ${line} | cut -d' ' -f$((4*loop+2))-$((4*loop+3)))
		if [ "${subbag_count}" == "" ] ; then break ; fi
		if [ "${subbag_name}" == "other bags." ] ; then break ; fi
		#echo "${subbag_name} - ${subbag_count}" >&2
		(( bagcount += $(get_bag_count "${subbag_name}") * ${subbag_count} ))
	done
	#echo "${bagcount}" >&2
	echo ${bagcount}
}

#start at the top of the tree and work my way down:
total_bags=$(( $(get_bag_count "shiny gold") - 1 ))
echo "Final bag count: ${total_bags}"
