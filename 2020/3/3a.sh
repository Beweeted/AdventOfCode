#!/bin/bash
input=input.txt

top=$(head -n 1 ${input})
width=${#top}
slope_x=3
slope_y=1

red='\e[31m'
green='\e[32m'
white='\e[0m'

row=0
current_location=0
trees=0
while read line ; do
	((row+=1))
	tree=false
	if [ ${current_location} -ge ${width} ] ; then ((current_location-=width)) ; fi
	#if [ ${current_location} -ge ${width} ] ; then ((current_location = current_location % width)) ; fi
	if [ "${line:current_location:1}" == "#" ] ; then ((trees+=1)) ; tree=true ; fi
	#echo "Row: ${row}, Location: ${current_location}, Value: ${line:current_location:1}, Tree: ${tree}"
	#echo "Line: ${line}"
	if [ "${tree}" == "true" ] ; then space="${red}#${white}" ; else space="${green}O${white}" ; fi

	printf "${line:0:current_location}${space}${line:current_location+1:width}\t\n"
	((current_location+=slope_x))
	for i in {0..10000} ; do echo -ne "" ; done
done < ${input}
echo "Trees: ${trees}"

#1234567890123456789012345678901
