
input=input_1a.txt

nums=($(cat ${input}))

answer=0
for num in ${nums[*]} ; do
	for num2 in ${nums[*]} ; do
		for num3 in ${nums[*]} ; do
			if [ $(( num + num2 + num3 )) -eq 2020 ] ; then
				answer=$(( num * num2 * num3 ))
				echo ${answer}
			fi
		done
	done
done
