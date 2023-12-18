import sys
input = sys.argv[1]

x = d = a = 0

for line in open(input, 'r'):
	command, inc = line.split()
	increment = int(inc)
	if command == 'down':
		a += increment
	if command == 'up':
		a -= increment
	if command == 'forward':
		x += increment
		d += a * increment
	print(f"Current location: ({x:4d},{d:4d}), aim: {a:4d}")



