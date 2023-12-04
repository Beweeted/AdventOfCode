#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

jolt_list=(0 0 0 1)
current=0

while read joltage ; do
	((jolts = joltage - current))
	((jolt_list[${jolts}]+=1))
	if [ ${jolts} -gt 3 ] ; then echo "wtf, check on joltage ${joltage}" ; break ; fi
	current=${joltage}
done < <(sort -n ${input})

echo "Jolt list: ${jolt_list[*]}"
answer=$(( ${jolt_list[1]} * ${jolt_list[3]} ))
echo "Puzzle answer: ${answer}"


