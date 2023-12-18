import sys
input = sys.argv[1]

x = d = 0

for line in open(input, 'r'):
	command, dist = line.split()
	distance = int(dist)
	if command == 'down':
		d += distance
	if command == 'up':
		d -= distance
	if command == 'forward':
		x += distance
	print(f"Current location: ({x:4d},{d:4d})")



