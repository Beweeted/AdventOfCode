import sys
input = sys.argv[1]

class GridLine:
	x1 = y1 = 0
	x2 = y2 = 0

	def __init__(self, point1, point2):
		x1 = point1[0]
		y1 = point1[1]
		x2 = point2[0]
		y2 = point2[1]


#vlines = []
#hlines = []
#dlines = []
lines = []
overlapping_tiles = set(())

for line in open(input, 'r'):
	coords_raw = line.split(' ')[0:3:2]
	c1 = [int(coords_raw[0].split(',')[0]),int(coords_raw[0].split(',')[1])]
	c2 = [int(coords_raw[1].split(',')[0]),int(coords_raw[1].split(',')[1].strip())]

	if c1[0] == c2[0]:
		print("Vertical!")
		#vlines.append(((c1[0],min(c1[1], c2[1])),(c2[0],max(c1[1], c2[1]))))
		lines.append(GridLine((c1[0],min(c1[1], c2[1])),(c2[0],max(c1[1], c2[1]))))
	elif c1[1] == c2[1]:
		print("Horizontal!")
		#hlines.append(((min(c1[0],c2[0]),c1[1]),(max(c1[0],c2[0]),c2[1])))
		lines.append(GridLine((min(c1[0],c2[0]),c1[1]),(max(c1[0],c2[0]),c2[1])))
	else:
		print("Diagonal!")
		pass #Diagonal

	print(c1)
	print(c2)
	print("")
	
for i in range(len(lines)):
	for j in range(i+1, len(lines)):
		if (lines[i].x1 <= lines[j].x2 <= lines[i].x2) and (lines[j].y1 <= lines[i].y2 <= lines[j].y2):
			for x in range(max(lines[i].x1,lines[i].x1), min(lines[i].x1, lines[i].x1)):
				for y in range(max(lines[i].y1,lines[i].y1), min(lines[i].y1, lines[i].y1)):
		elif (lines[j].x1 <= lines[i].x2 <= lines[j].x2) and (lines[i].y1 <= lines[j].y2 <= lines[i].y2):


#Intersectional overlap
for vline in vlines:
	for hline in hlines:
		if (hline[0][0] <= vline[0][0] <= hline[1][0] or 
		    hline[1][0] <= vline[0][0] <= hline[0][0] or
		    vline[0][1] <= hline[0][1] <= vline[1][1] or
		    vline[1][1] <= hline[0][1] <= vline[1][1]):
				print("Intersection!")
				overlapping_tiles.add((vline[0][0],hline[0][1]))

#Vertical overlap
for i in range(len(vlines)):
	for j in range(i+1, len(vlines)):
		#between the highest bottom point and the lowest top point
		line1 = vlines[i]
		line2 = vlines[j]

		#same X and overlapping Y
		if line1[0][0] == line2[0][0] and 
			(line1[0][1] >= line2[0][1] <= line1[1][1] or
			 line1[0][1] >= line2[1][1] <= line1[1][1]) :
				for spot in range(max(line1[0][1],line2[0][1]), min(line1[1][1], line2[1][1])):
					overlapping_tiles.add((line1[0][0],spot))

#Horizontal overlap
for i in range(len(hlines)):
	for j in range(i+1, len(hlines)):
		#between the highest bottom point and the lowest top point
		line1 = hlines[i]
		line2 = hlines[j]

		#same Y and overlapping X
		if line1[0][1] == line2[0][1] and 
			(line1[0][1] >= line2[0][1] <= line1[1][1] or
			 line1[0][1] >= line2[1][1] <= line1[1][1]) :
				for spot in range(max(line1[0][1],line2[0][1]), min(line1[1][1], line2[1][1])):
					overlapping_tiles.add((line1[0][0],spot))

a: 7,3 -> 7,6
b: 7,5 -> 7,7	#first end is inside
c: 7,0 -> 7,4	#second end is inside
d: 7,4 -> 7,5   #both ends are inside the other
e: 7,0 -> 7,2	#neither end is inside

max(a[0],b[0]), min(a[1],b[1])

a->b: 5, 6		5,6
a->c: 3, 4		3,4
a->d: 4, 5		4,5
a->e: (none)	




			top_of_bottom = max(line1[0][1], line2[0][1])
			bottom_of_top = max(line1[1][1], line2[1][1])
			overlap = max(line1[0][1], line2[0][1])
		if vlines[i][0][0] == vlines[j][0][0]:
			for k in range(<Something that gets just the overlap>)


#Horizontal overlap


print("Overlapping tiles:", overlapping_tiles)

# Remove lines that are not straight (where x!=x && y!=y)
# Sort lines into vertical vs horizontal
# Compare vertical vs horizontal for intersects
# Compare v vs v and h vs h for overlaps

