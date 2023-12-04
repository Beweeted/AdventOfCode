#!/bin/bash
input=input.txt

top=$(head -n 1 ${input})
width=${#top}
slope_x=(1 3 5 7 1)
slope_y=(1 1 1 1 2)

red='\e[31m'
green='\e[32m'
white='\e[0m'

row=0
locations=(0 0 0 0 0)
trees=(0 0 0 0 0)
while read line ; do
	((row+=1))
	output=""

	for i in {0..4} ; do
		x=${slope_x[i]}
		y=${slope_y[i]}

		current_location=${locations[i]}

		#echo "${x} - ${y} - ${locations[*]}"
		if [ ${current_location} -ge ${width} ] ; then ((current_location-=width)) ; fi

		if [ $(( (row - 1) % y )) -eq 0 ] ; then 
			if [ "${line:current_location:1}" == "#" ] ; then 
				((trees[i]+=1))
				space="${red}#${white}"
			else
				space="${green}O${white}"
			fi
			locations[${i}]=$((current_location + x))
		else
			space="${line:current_location:1}"
		fi

		#if [ "${tree}" == "true" ] ; then space="${red}#${white}" ; else space="${green}O${white}" ; fi
		#space=${line:current_location:1}

		output+="${line:0:current_location}${space}${line:current_location+1:width}\t\t"
		
		#locations[${i}]=$((current_location + x))

		for i in {0..10000} ; do echo -ne "" ; done
	done
	printf "${output}\n"
done < ${input}
echo "Trees: ${trees[*]}"
echo "Multiplicative sum: $(( trees[0] * trees[1] * trees[2] * trees[3] * trees[4] ))"

#1234567890123456789012345678901
