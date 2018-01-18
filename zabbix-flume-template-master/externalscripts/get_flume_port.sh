#!/bin/bash

portarray=(`ps -ef | egrep -o 'flume.monitoring.port=[0-9]+' | egrep -o '[0-9]+'`)

length=${#portarray[@]}

printf "{"
printf "\"data\":["

for ((i=0; i<$length;i++))
   do 
	printf "{\"{#FLUME_METRICS_PORT}\":\"${portarray[$i]}\"}"
	if [ $i -lt $[$length-1] ]; then
		printf ','
	fi
   done

printf "]"
printf "}"

