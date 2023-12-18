import sys
from enum import Enum

input = sys.argv[1]

def is_zero_most_common_for_position(stringList, position):
	count = total = 0
	for s in stringList:
		try:
			total += int(s[position])
		except:
			print("Dumping:", position, stringList)
			total += int(s[position])
		count += 1
	if total < count / 2:
		zeroMostCommon = True
	else:
		zeroMostCommon = False

	print("Count:", count, "Total:", total, "Zero Most Common:", zeroMostCommon)
	return zeroMostCommon

def get_single_value(stringList, common):
	#Given a list of binary strings, and a rarity, whittle away a list to get only a single value remaining.
	#Common = True  --> most common values
	#Common = False --> least common values
	places = len(stringList[0])
	for i in range(places):
		print("Current position:", i, "Commonality:", common)
		zeroMostCommon = is_zero_most_common_for_position(stringList, i)
		if zeroMostCommon:
			if common:
				purgeValue = '1'
			else:
				purgeValue = '0'
		else:
			if common:
				purgeValue = '0'
			else:
				purgeValue = '1'

		print("Purging value:", purgeValue)
		purgingList = stringList[:]
		for s in purgingList:
			if s[i] == purgeValue:
				stringList.remove(s)
		if len(stringList) == 1:
			print('')
			break
		print("Current list:", stringList)
	return stringList[0]

places = 0
with open(input, 'r') as f:
	places = len(f.readline().strip())

oxyValues = []
co2Values = []
for line in open(input, 'r'):
	oxyValues.append(line.strip())
	co2Values.append(line.strip())

print('Processing Oxygen values.')
oxyBinary = get_single_value(oxyValues, True)
print('Processing CO2 values.')
co2Binary = get_single_value(co2Values, False)

oxyDec = int(oxyBinary,2)
co2Dec = int(co2Binary,2)

print(f'Final binary values.  oxyBinary: {oxyBinary}  co2Binary: {co2Binary}')
print(f'Final decimal values. oxyDec: {oxyDec}  co2Dec: {co2Dec}')
print(f'Multiplied value: {oxyDec * co2Dec}')

