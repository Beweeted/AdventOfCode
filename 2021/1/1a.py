increases = decreases = same = total = 0
previousDepth = 0

file = open('input.txt', 'r')
for line in file:
	depth = int(line)
	total += 1

	if total == 1:
		same += 1
	elif previousDepth > depth:
		decreases += 1
	elif previousDepth < depth:
		increases += 1
	else:
		same += 1

	previousDepth = depth

file.close()
print("Increases: {}".format(increases))
print("Decreases: {}".format(decreases))
print("Same: {}".format(same))
print("Total: {}".format(total))
print("Total matches expected") if total == increases + decreases + same else print("Total is {} too many".format(total - increases - decreases - same))

