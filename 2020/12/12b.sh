#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

ship_x=0
ship_y=0

waypoint_x=10
waypoint_y=1

echo "Coords: (${ship_x}, ${ship_y})  Waypoint: (${waypoint_x},${waypoint_y})  Instruction: ${instruction}"

while read instruction ; do
	letter=${instruction:0:1}
	number=${instruction:1}
#	for i in {0..10000} ; do echo -ne "" ; done
	case ${letter} in
		N)
			((waypoint_y+=number))
			;;
		S)
			((waypoint_y-=number))
			;;
		E)
			((waypoint_x+=number))
			;;
		W)
			((waypoint_x-=number))
			;;
		L|R)
			tmp_x=${waypoint_x}
			tmp_y=${waypoint_y}
			case ${instruction} in
				R90|L270)
#if (+,+) -> (+,-)
#if (+,-) -> (-,-)
#if (-,-) -> (-,+)
#if (-,+) -> (+,+)

#if (+2,+3) -> (+3,-2)
#if (+3,-2) -> (-2,-3)
#if (-2,-3) -> (-3,+2)
#if (-3,+2) -> (+2,+3)
		#			if [[ $(( waypoint_x * waypoint_y )) -gt 0 ]] ; then
						((waypoint_x = ${tmp_y} * 1))
						((waypoint_y = ${tmp_x} * -1))
		#			else
		#				((waypoint_x = ${tmp_y} * -1))
		#				((waypoint_y = ${tmp_x} * 1))
		#			fi
					;;
				R270|L90)
		#			if [[ $(( waypoint_x * waypoint_y )) -gt 0 ]] ; then
						((waypoint_x = ${tmp_y} * -1))
						((waypoint_y = ${tmp_x} * 1))
		#			else
		#				((waypoint_x = ${tmp_y} * 1))
		#				((waypoint_y = ${tmp_x} * -1))
		#			fi
					;;
				R180|L180)
						((waypoint_x = ${tmp_x} * -1))
						((waypoint_y = ${tmp_y} * -1))
					;;
				*)
					echo "Hey, unexpected direction turning happening here: ${instruction}"
					;;
			esac
			;;
		F)
			
			((ship_x += waypoint_x * number))
			((ship_y += waypoint_y * number))
			;;
		esac
	echo "Coords: (${ship_x}, ${ship_y})  Waypoint: (${waypoint_x},${waypoint_y})  Instruction: ${instruction}"
done < ${input}
echo "Coords: (${ship_x}, ${ship_y})"
if [ ${ship_x} -lt 0 ] ; then ((ship_x*=-1)) ; fi
if [ ${ship_y} -lt 0 ] ; then ((ship_y*=-1)) ; fi

echo "Man Dist: $((ship_x+ship_y))"
