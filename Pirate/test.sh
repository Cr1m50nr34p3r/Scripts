#!/bin/bash
declare -a arr=()
seqnc=$(seq 1 12)
for i in $seqnc
do
    echo $i
    arr+=("$seqnc")
done
echo ${#arr[@]}
