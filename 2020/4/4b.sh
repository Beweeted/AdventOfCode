#!/bin/bash
input=input.txt

valid_count=0

red='\e[31m'
green='\e[32m'
white='\e[0m'

get_color() {
	if [ $1 -eq 1 ] ; then
		echo "${green}"
	else
		echo "${red}"
	fi
}

byr_valid=0
iyr_valid=0
eyr_valid=0
hgt_valid=0
hcl_valid=0
ecl_valid=0
pid_valid=0
cid_valid=1


printf "Field:\t\t\tres\tbyr\tiyr\teyr\thgt\thcl\tecl\tpid\tcid\n"
while read line ; do
	if [ "${line}" == "" ] ; then
		result="${red}FAIL${white}"
		if [ $(( byr_valid + iyr_valid + eyr_valid + hgt_valid + hcl_valid + ecl_valid + pid_valid + cid_valid )) -eq 8 ] ; then
			((valid_count+=1))
			result="${green}PASS${white}"
		fi
		output="Passport results:\t${result}\t"
		output+="$(get_color ${byr_valid})${byr_valid}${white}\t"
		output+="$(get_color ${iyr_valid})${iyr_valid}${white}\t"
		output+="$(get_color ${eyr_valid})${eyr_valid}${white}\t"
		output+="$(get_color ${hgt_valid})${hgt_valid}${white}\t"
		output+="$(get_color ${hcl_valid})${hcl_valid}${white}\t"
		output+="$(get_color ${ecl_valid})${ecl_valid}${white}\t"
		output+="$(get_color ${pid_valid})${pid_valid}${white}\t"
		output+="$(get_color ${cid_valid})${cid_valid}${white}\t"
		printf "${output}\n"
		byr_valid=0
		iyr_valid=0
		eyr_valid=0
		hgt_valid=0
		hcl_valid=0
		ecl_valid=0
		pid_valid=0
		cid_valid=1
		continue
	fi
	for field in ${line} ; do
		((field_count+=1))
		key=$(echo ${field} | cut -d':' -f1)
		value=$(echo ${field} | cut -d':' -f2)

		case "${key}" in
			"byr")
				if [[ ${#value} -eq 4 && ${value} -ge 1920 && ${value} -le 2002 ]] ; then byr_valid=1 ; fi ;;
			"iyr")
				if [[ ${#value} -eq 4 && ${value} -ge 2010 && ${value} -le 2020 ]] ; then iyr_valid=1 ; fi ;;
			"eyr")
				if [[ ${#value} -eq 4 && ${value} -ge 2020 && ${value} -le 2030 ]] ; then eyr_valid=1 ; fi ;;
			"hgt")
				units=${value: -2}
				height=${value%??}
				case ${units} in
					cm)
						min=150
						max=193
						if [[ ${height} -ge ${min} && ${height} -le ${max} ]] ; then
							hgt_valid=1
						fi
						;;
					in)
						min=59
						max=76
						if [[ ${height} -ge ${min} && ${height} -le ${max} ]] ; then
							hgt_valid=1
						fi
						;;
				esac
				;;
			"hcl")
				if [[ ${value} =~ ^[#][a-fA-F0-9]+$ && ${#value} -eq 7 ]] ; then hcl_valid=1 ; fi ;;
			"ecl")
				case ${value} in amb|blu|brn|gry|grn|hzl|oth) ecl_valid=1 ;;
				esac
				;;
			"pid")
				if [[ ${value} =~ ^[0-9]+$ && ${#value} -eq 9 ]] ; then
					pid_valid=1
				fi
				;;
		esac
	done
done < ${input}
echo "Valid passports: ${valid_count}"
