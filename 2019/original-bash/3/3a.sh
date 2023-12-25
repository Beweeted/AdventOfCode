log=log.txt
intersections=intersections.txt
ints=intersections2.txt

input=${1}

: ${input:=input_3a.txt}
echo "Input: ${input}"

parse_wires() {
loop=0
rm wire{1,2}{H,V}.txt
for i in 1 2 ; do 
    x=0
    y=0
	subloop=0
    for direction in $(sed "${i}q;d" ${input} | sed 's/,/ /g') ; do
        dir=${direction:0:1}
        dist=${direction:1}
        #echo "Dir: ${dir}   Dist: ${dist}"
        echo -ne "\r${loop}"
        loop=$(( loop + 1 ))
        subloop=$(( subloop + 1 ))
        case ${dir} in
          R)
            nx=$(( x + dist ))
            ny=${y}
            angle=H
          ;;
          L)
            nx=$(( x - dist ))
            ny=${y}
            angle=H
          ;;
          U)
            nx=${x}
            ny=$(( y + dist ))
            angle=V
          ;;
          D)
            nx=${x}
            ny=$(( y - dist ))
            angle=V
          ;;
          *)
            echo "UNKNOWN DIRECTION: ${direction}"
            echo "${dir}"
          ;;
        esac
        
        echo "${subloop}:${x},${y}:${nx},${ny}" >> wire${i}${angle}.txt
        x=${nx}
        y=${ny}
    done
done
echo ""
echo ""
}

log_intersections(){
seg1=$1
seg2=$2
segnum=$(echo "${seg1}" | cut -d':' -f1)
x1=$(echo "${seg1}" | cut -d':' -f2 | cut -d',' -f1)
y1=$(echo "${seg1}" | cut -d':' -f2 | cut -d',' -f2)
x2=$(echo "${seg1}" | cut -d':' -f3 | cut -d',' -f1)
y2=$(echo "${seg1}" | cut -d':' -f3 | cut -d',' -f2)
csegnum=$(echo "${seg2}" | cut -d':' -f1)
cx1=$(echo "${seg2}" | cut -d':' -f2 | cut -d',' -f1)
cy1=$(echo "${seg2}" | cut -d':' -f2 | cut -d',' -f2)
cx2=$(echo "${seg2}" | cut -d':' -f3 | cut -d',' -f1)
cy2=$(echo "${seg2}" | cut -d':' -f3 | cut -d',' -f2)

#if the first line is vertical
if [[ ${x1} -eq ${x2} ]] ; then
    if [[ $(( ( cx1 - x1 ) * ( cx2 - x1 ) )) -lt 0 && $(( ( y1 - cy1 ) * ( y2 - cy1 ) )) -lt 0 ]] ; then
        echo "$(( ${x1#-} + ${cy1#-} ))" >> ${intersections}
        echo "${segnum}-${csegnum}: (${x1},${cy1}) - $(( ${x1#-} + ${cy1#-} ))" >> ${ints}
        echo "Logged Vertical! ${seg1} - ${seg2}"
    fi
#else the first line is horizontal
else
    if [[ $(( ( x1 - cx1 ) * ( x2 - cx1 ) )) -lt 0 && $(( ( cy1 - y1 ) * ( cy2 - y1 ) )) -lt 0 ]] ; then
        echo "$(( ${cx1#-} + ${y1#-} ))" >> ${intersections}
        echo "${segnum}-${csegnum}: (${cx1},${y1}) - $(( ${cx1#-} + ${y1#-} ))" >> ${ints}
        echo "Logged Horizontal! ${seg1} - ${seg2}"
    fi
fi

echo "${seg1} - ${seg2}" >> ${log}

}

find_closest_intersection3(){
d=$1
s1=$2
subloop=1
while read w2seg ; do 
    #log_intersections "${s1}" "${w2seg}" &
    log_intersections "${s1}" "${w2seg}"
	subloop=$(( subloop + 1 ))
done < wire2${d}.txt
wait
}

find_closest_intersection2(){
date
trap date EXIT
rm ${intersections} ${log}
loop=1
while read w1seg ; do
    echo -ne "\r${loop}"
    #find_closest_intersection3 V ${w1seg} &
    find_closest_intersection3 V ${w1seg}
    loop=$(( loop + 1 ))
done < wire1H.txt
while read w1seg ; do
    echo -ne "\r${loop}"
    #find_closest_intersection3 H ${w1seg} &
    find_closest_intersection3 H ${w1seg}
    loop=$(( loop + 1 ))
done < wire1V.txt
wait
echo ""
}

parse_wires
find_closest_intersection2
wait
sort -n ${intersections} | head -n 1
#echo "Number of loops: ${loop}"
