import sys
input = sys.argv[1]

#This puzzle took me way too long. I thought of doing this and went "naw, it needs to be dynamic in a future puzzle."
#I forgot to actually check whether the demo input and real input were the same number of places.
sums = []
f = open(input, 'r')
places = len(f.readline())-1
for p in range(places):
	sums.append(0)
f.close()

count = 0
for line in open(input, 'r'):
	count += 1
	for i in range(places):
		sums[i] += int(line[i])

gamma = ''
epsilon = ''

for i in range(places):
	print('Dominant value: ', end='')
	if sums[i] > count / 2:
		gamma   += '1'
		epsilon += '0'
		print('1', end='')
	else:
		gamma   += '0'
		epsilon += '1'
		print('0', end='')
	print(f'  Comparison: {sums[i]} vs {count}')

gammaD   = int(gamma,2)
epsilonD = int(epsilon,2)

print(f'Final binary values.  Gamma: {gamma}  Epsilon: {epsilon}')
print(f'Final decimal values. Gamma: {gammaD}  Epsilon: {epsilonD}')
print(f'Multiplied value: {gammaD * epsilonD}')
