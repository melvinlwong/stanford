#!/bin/bash
#
# Adding comments with spaces originally written for NetDB
#
#
hosts=($(cat machines))
#
comment()
{
IFS=$'\n'

# read all file name into an array
fileArray=($(cat comments))
 
# restore it 
IFS=$OLDIFS
 
# get length of an array
tLen=${#fileArray[@]}
 
}

# use for loop read all filenames
for c in ${!hosts[*]}
do
comment $c
printf 'node comment --set %s %s\n' "${fileArray[$c]}" ${hosts[c]}
done
