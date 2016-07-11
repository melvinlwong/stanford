#!/bin/bash

i=1
#
while [ $i -lt 300 ]
do
	#echo "hello world - $i" >> /mnt/helloworld
        date > /mnt/helloworld
	sleep 1
	i=`expr $i + 1`
done
