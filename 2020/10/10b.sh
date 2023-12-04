#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'


combinations=(0 1 1 2 4 7)

longest=1
last_num=0
current=1
new_line=true

possibilities=1
chain=1
while read jolts ; do
	joltage=$((jolts-last_num))
	case ${joltage} in
		1)
			echo "Incrementing..."
			((current+=1))
			((chain+=1))
			;;
		2)
			echo "This joltage doesn't actually appear in the data."
			;;
		3)
			echo "New chain!"
			possibilities=$(( possibilities * ${combinations[chain]} ))
			current=1
			chain=1
			;;
	esac
	last_num=${jolts}
done < <(sort -n ${input})
echo "Total possibilities: ${possibilities}"
