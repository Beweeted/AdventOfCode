import sys
input = sys.argv[1]

increases = decreases = same = total = 0
pDepth1 = pDepth2 = 0

multidepths = []

for line in open(input, 'r'):
	depth = int(line)
	if pDepth2 != 0:
		aggregateDepth = pDepth2 + pDepth1 + depth
		multidepths.append(aggregateDepth)
	pDepth2 = pDepth1
	pDepth1 = depth

print(f"Multidepths measured: {len(multidepths)}")

previousDepth = 0
for depth in multidepths:
	print(f"Comparing previous {previousDepth:4d} with current {depth:4d}. Result: ", end='')
	if previousDepth != 0:
		if previousDepth > depth:
			decreases += 1
			print("   vvv", end='')
		elif previousDepth < depth:
			increases += 1
			print("^^^   ", end='')
		else:
			same += 1
			print("------", end='')
	else:
		same += 1
		print("------", end='')

	total += 1
	previousDepth = depth
	print(f"  Current counts +:{increases:3d} -:{decreases:3d}")

print(f"Increases: {increases}")
print(f"Decreases: {decreases}")
print(f"Same: {same}")
print(f"Total: {total}")
print("Total matches expected") if total == increases + decreases + same else print(f"Total is {total - increases - decreases - same} too many")

