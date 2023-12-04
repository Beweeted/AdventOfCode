#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

base_time=$(head -n 1 ${input})
schedule=($(tail -n 1 ${input} | sed 's/,/ /g'))

best_bus=0
((best_time=base_time*2))

for s in ${schedule[*]} ; do
	if [ ${s} == "x" ] ; then 
		echo "Skipping..."
		continue
	fi
	a=$((base_time / s))
	bus_time=$((a * s + s))
	if [ ${bus_time} -lt ${best_time} ] ; then 
		best_time=${bus_time}
		best_bus=${s}
		echo "New best bus: ${best_bus}  New best time: ${best_time}"
	else
		echo "Bus too slow: ${s}  Bus time: ${bus_time}"
	fi
done

echo "Start time: ${base_time}"
echo "Best bus: ${best_bus}"
echo "Soonest time: ${best_time}"

echo "Calculation: ${best_bus}*(${best_time}-${base_time})"
echo "Result: $(( best_bus*(best_time-base_time) ))"

