#!/bin/bash
input=test_b_input.txt
tmp=tmp.txt

red='\e[31m'
green='\e[32m'
yellow='\e[93m'
white='\e[0m'

prime_factors() {
    n=$1
    i=2
    factors=()
    while [ $(( i * i )) -le ${n} ] ; do
        if [ $(( n % i )) -eq 0 ] ; then
            ((i+=1))
        else
            ((n/=i))
            factors+=(${i})
        fi
    done
    if [ ${n} -gt 1 ] ; then
        factors+=(n)
    fi
    echo ${factors[*]}
}

rm ${tmp}
while read line ; do
    unset schedule
    schedule=($(echo ${line} | sed 's/,/ /g'))
    
    for s in ${schedule[*]} ; do
        prime_factors ${s} >> ${tmp}
    done
done < ${input}

#Well shit, I don't want LCM, I want where the multiple of one is different from the multiple of another by X amount.
while read line ; do
    for i in 

Loop: 12175256  Start time: 7463431880

7463431880
100000000000000