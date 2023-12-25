input=${1}

: ${input:=input_3a.txt}
echo "Input: ${input}"

HORIZONTAL=H
VERTICAL=V

parse_wires() {
mysql --login-path=admin -h localhost test -e"DROP TABLE IF EXISTS wire_segments; CREATE TABLE wire_segments (
wire_id tinyint,
wire_segment int,
wire_direction varchar(10),
wire_start_x smallint,
wire_start_y smallint,
wire_end_x smallint,
wire_end_y smallint,
wire_length int,
PRIMARY KEY (wire_id, wire_segment)
);"

for i in 1 2 ; do 
	loop=0
	angle=''
    x=0
    y=0
	dist=0
	nx=0
	ny=0
    for direction in $(sed "${i}q;d" ${input} | sed 's/,/ /g') ; do
		#if [ ${loop} -eq 0 ] ; then echo -ne "\n${i},${loop},'${angle}',${x},${y},${nx},${ny},${dist}\n" ; fi
        dir=${direction:0:1}
        dist=${direction:1}
        #echo "Dir: ${dir}   Dist: ${dist}"
        echo -ne "\rWire ${i} length: ${loop}"
        loop=$(( loop + 1 ))
        case ${dir} in
          R)
            nx=$(( x + dist ))
            ny=${y}
            angle=${HORIZONTAL}
          ;;
          L)
            nx=$(( x - dist ))
            ny=${y}
            angle=${HORIZONTAL}
          ;;
          U)
            nx=${x}
            ny=$(( y + dist ))
            angle=${VERTICAL}
          ;;
          D)
            nx=${x}
            ny=$(( y - dist ))
            angle=${VERTICAL}
          ;;
          *)
            echo "UNKNOWN DIRECTION: ${direction}"
            echo "${dir}"
			exit
          ;;
        esac
		
		#if [ ${loop} -eq 1 ] ; then echo -ne "\n${i},${loop},'${angle}',${x},${y},${nx},${ny},${dist}\n" ; fi

		INSERT_VALUES="(${i},${loop},'${angle}',${x},${y},${nx},${ny},${dist})"
		mysql --login-path=admin -h localhost test -e"INSERT INTO wire_segments VALUES ${INSERT_VALUES};"
        #echo "${x},${y}:${nx},${ny}" >> wire${i}${angle}.txt
		
        x=${nx}
        y=${ny}
    done
	echo ""
done
}

check_for_intersections_3a() {
QUERY="SELECT CONCAT('(', a.wire_segment, ',', b.wire_segment, ')'), b.wire_start_x, a.wire_start_y
FROM wire_segments AS a
JOIN wire_segments AS b

WHERE a.wire_id = 1
AND b.wire_id = 2
AND a.wire_direction = 'H'
AND b.wire_direction = 'V'

AND ((
    a.wire_start_x < b.wire_start_x  #Right
AND a.wire_end_x   > b.wire_start_x
AND b.wire_start_y < a.wire_start_y  #Up
AND b.wire_end_y   > a.wire_start_y
) OR (
    a.wire_start_x > b.wire_start_x  #Left
AND a.wire_end_x   < b.wire_start_x
AND b.wire_start_y > a.wire_start_y  #Down
AND b.wire_end_y   < a.wire_start_y
) OR (
    a.wire_start_x < b.wire_start_x  #Right
AND a.wire_end_x   > b.wire_start_x
AND b.wire_start_y > a.wire_start_y  #Down
AND b.wire_end_y   < a.wire_start_y
) OR (
    a.wire_start_x > b.wire_start_x  #Left
AND a.wire_end_x   < b.wire_start_x
AND b.wire_start_y < a.wire_start_y  #Up
AND b.wire_end_y   > a.wire_start_y
))

UNION

SELECT CONCAT('(', a.wire_segment, ',', b.wire_segment, ')'), a.wire_start_x, b.wire_start_y
FROM wire_segments AS a
JOIN wire_segments AS b

WHERE a.wire_id = 1
AND b.wire_id = 2
AND a.wire_direction = 'V'
AND b.wire_direction = 'H'

AND ((
    b.wire_start_x < a.wire_start_x  #Right
AND b.wire_end_x   > a.wire_start_x
AND a.wire_start_y < b.wire_start_y  #Up
AND a.wire_end_y   > b.wire_start_y
) OR (
    b.wire_start_x > a.wire_start_x  #Left
AND b.wire_end_x   < a.wire_start_x
AND a.wire_start_y > b.wire_start_y  #Down
AND a.wire_end_y   < b.wire_start_y
) OR (
    b.wire_start_x > a.wire_start_x  #Left
AND b.wire_end_x   < a.wire_start_x
AND a.wire_start_y < b.wire_start_y  #Up
AND a.wire_end_y   > b.wire_start_y
) OR (
    b.wire_start_x < a.wire_start_x  #Right
AND b.wire_end_x   > a.wire_start_x
AND a.wire_start_y > b.wire_start_y  #Down
AND a.wire_end_y   < b.wire_start_y
))
;"

while read a x y ; do
	echo -e "$(( ${x#-} + ${y#-} ))\t${a}"
done < <(mysql --login-path=admin -h localhost test -e"${QUERY}" -NB | sed 's/\r//g')
}

check_for_intersections_3b() {
#QUERY="SELECT a.wire_segment, b.wire_segment, abs(b.wire_start_x) + abs(a.wire_start_y) AS 'intersection_length'
QUERY="SELECT a.wire_segment, b.wire_segment, abs(a.wire_start_x - b.wire_start_x) + abs(b.wire_start_y - a.wire_start_y) AS 'intersection_length'
FROM wire_segments AS a
JOIN wire_segments AS b

WHERE a.wire_id = 1
AND b.wire_id = 2
AND a.wire_direction = 'H'
AND b.wire_direction = 'V'

AND ((
    a.wire_start_x < b.wire_start_x  #Right
AND a.wire_end_x   > b.wire_start_x
AND b.wire_start_y < a.wire_start_y  #Up
AND b.wire_end_y   > a.wire_start_y
) OR (
    a.wire_start_x > b.wire_start_x  #Left
AND a.wire_end_x   < b.wire_start_x
AND b.wire_start_y > a.wire_start_y  #Down
AND b.wire_end_y   < a.wire_start_y
) OR (
    a.wire_start_x < b.wire_start_x  #Right
AND a.wire_end_x   > b.wire_start_x
AND b.wire_start_y > a.wire_start_y  #Down
AND b.wire_end_y   < a.wire_start_y
) OR (
    a.wire_start_x > b.wire_start_x  #Left
AND a.wire_end_x   < b.wire_start_x
AND b.wire_start_y < a.wire_start_y  #Up
AND b.wire_end_y   > a.wire_start_y
))

UNION

SELECT a.wire_segment, b.wire_segment, abs(b.wire_start_x - a.wire_start_x) + abs(a.wire_start_y - b.wire_start_y) AS 'intersection_length'
FROM wire_segments AS a
JOIN wire_segments AS b

WHERE a.wire_id = 1
AND b.wire_id = 2
AND a.wire_direction = 'V'
AND b.wire_direction = 'H'

AND ((
    b.wire_start_x < a.wire_start_x  #Right
AND b.wire_end_x   > a.wire_start_x
AND a.wire_start_y < b.wire_start_y  #Up
AND a.wire_end_y   > b.wire_start_y
) OR (
    b.wire_start_x > a.wire_start_x  #Left
AND b.wire_end_x   < a.wire_start_x
AND a.wire_start_y > b.wire_start_y  #Down
AND a.wire_end_y   < b.wire_start_y
) OR (
    b.wire_start_x > a.wire_start_x  #Left
AND b.wire_end_x   < a.wire_start_x
AND a.wire_start_y < b.wire_start_y  #Up
AND a.wire_end_y   > b.wire_start_y
) OR (
    b.wire_start_x < a.wire_start_x  #Right
AND b.wire_end_x   > a.wire_start_x
AND a.wire_start_y > b.wire_start_y  #Down
AND a.wire_end_y   < b.wire_start_y
));"

while read seg1 seg2 dist ; do
	#echo ${seg1} ${seg2} ${dist}
	mysql --login-path=admin -h localhost test -NB -e"SELECT sum(wire_length) + ${dist}, CONCAT('(', ${seg1}, ',', ${seg2}, ')') FROM wire_segments WHERE (wire_id = 1 AND wire_segment < ${seg1}) OR (wire_id = 2 AND wire_segment < ${seg2})"
done < <(mysql --login-path=admin -h localhost test -e"${QUERY}" -NB | sed 's/\r//g')
}

old_check_for_intersections_3a() {
QUERY="SELECT CONCAT('(', a.wire_segment, ',', b.wire_segment, ')'), b.wire_start_x, a.wire_start_y
FROM wire_segments AS a
JOIN wire_segments AS b

ON  a.wire_start_x < b.wire_start_x 
AND a.wire_end_x   > b.wire_start_x
AND b.wire_start_y < a.wire_start_y
AND b.wire_end_y   > a.wire_start_y

WHERE a.wire_id = 1
AND b.wire_id = 2
AND a.wire_direction = 'H'
AND b.wire_direction = 'V'

UNION

SELECT CONCAT('(', a.wire_segment, ',', b.wire_segment, ')'), a.wire_start_x, b.wire_start_y
FROM wire_segments AS a
JOIN wire_segments AS b

ON  b.wire_start_x < a.wire_start_x 
AND b.wire_end_x   > a.wire_start_x
AND a.wire_start_y < b.wire_start_y
AND a.wire_end_y   > b.wire_start_y

WHERE a.wire_id = 1
AND b.wire_id = 2
AND a.wire_direction = 'V'
AND b.wire_direction = 'H';"

while read a x y ; do
	echo -e "${a}\t$(( ${x#-} + ${y#-} ))"
done < <(mysql --login-path=admin -h localhost test -e"${QUERY}" -NB | sed 's/\r//g')
}

old_check_for_intersections_3b() {
#QUERY="SELECT a.wire_segment, b.wire_segment, abs(b.wire_start_x) + abs(a.wire_start_y) AS 'intersection_length'
QUERY="SELECT a.wire_segment, b.wire_segment, abs(a.wire_start_x - b.wire_start_x) + abs(b.wire_start_y - a.wire_start_y) AS 'intersection_length'
FROM wire_segments AS a
JOIN wire_segments AS b

ON  a.wire_start_x < b.wire_start_x 
AND a.wire_end_x   > b.wire_start_x
AND b.wire_start_y < a.wire_start_y
AND b.wire_end_y   > a.wire_start_y

WHERE a.wire_id = 1
AND b.wire_id = 2
AND a.wire_direction = 'H'
AND b.wire_direction = 'V'

UNION

SELECT a.wire_segment, b.wire_segment, abs(b.wire_start_x - a.wire_start_x) + abs(a.wire_start_y - b.wire_start_y) AS 'intersection_length'
FROM wire_segments AS a
JOIN wire_segments AS b

ON  b.wire_start_x < a.wire_start_x 
AND b.wire_end_x   > a.wire_start_x
AND a.wire_start_y < b.wire_start_y
AND a.wire_end_y   > b.wire_start_y

WHERE a.wire_id = 1
AND b.wire_id = 2
AND a.wire_direction = 'V'
AND b.wire_direction = 'H';"

while read seg1 seg2 dist ; do
	#echo ${seg1} ${seg2} ${dist}
	mysql --login-path=admin -h localhost test -NB -e"SELECT ${seg1}, ${seg2}, sum(wire_length) + ${dist} FROM wire_segments WHERE (wire_id = 1 AND wire_segment < ${seg1}) OR (wire_id = 2 AND wire_segment < ${seg2})"
done < <(mysql --login-path=admin -h localhost test -e"${QUERY}" -NB | sed 's/\r//g')
}

parse_wires
echo "Puzzle 3a distance" $(date)
#check_for_intersections_3a
check_for_intersections_3a | sort -n | head -n 1
echo "Puzzle 3b distance" $(date)
#check_for_intersections_3b
check_for_intersections_3b | sort -n | head -n 1
echo "Complete" $(date)


