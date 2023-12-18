#!/bin/bash
input=input.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

ship_x=0
ship_y=0

face=1

facing=(0 East South West North)
echo "Coords: (${ship_x}, ${ship_y})  Facing: ${facing[face]}  Instruction: ${instruction}"

while read instruction ; do
	letter=${instruction:0:1}
	number=${instruction:1}
#	for i in {0..10000} ; do echo -ne "" ; done
	case ${letter} in
		N)
			((ship_y+=number))
			;;
		S)
			((ship_y-=number))
			;;
		E)
			((ship_x+=number))
			;;
		W)
			((ship_x-=number))
			;;
		L|R)
			case ${instruction} in
				R90|L270)
					((face+=1))
					;;
				R270|L90)
					((face+=3))
					;;
				R180|L180)
					((face+=2))
					;;
				*)
					echo "Hey, unexpected direction turning happening here: ${instruction}"
					;;
			esac
			#Spin down by 360 degrees if we went too far.
			if [ ${face} -gt 4 ] ; then ((face -= 4)) ; fi
			;;
		F)
			case ${face} in
				1)
					((ship_x+=number))
					;;
				2)
					((ship_y-=number))
					;;
				3)
					((ship_x-=number))
					;;
				4)
					((ship_y+=number))
					;;
			esac
			;;
		esac
	echo "Coords: (${ship_x}, ${ship_y})  Facing: ${facing[face]}  Instruction: ${instruction}"
done < ${input}
echo "Coords: (${ship_x}, ${ship_y})"
if [ ${ship_x} -lt 0 ] ; then ((ship_x*=-1)) ; fi
if [ ${ship_y} -lt 0 ] ; then ((ship_y*=-1)) ; fi

echo "Man Dist: $((ship_x+ship_y))"
