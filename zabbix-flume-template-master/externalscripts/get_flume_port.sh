#!/bin/bash


case $1 in:
source_port)

		pid_str=$(ps -ef | grep 'org.apache.flume.node.Application ' | grep -v 'color=auto' | awk '{print $2}' | tr -t '\n' '|' | sed 's/.$//')
		portarray=$(netstat -tunlp | egrep "$pid_str" | awk '{print $4}'| awk -F ":" '{print $NF}' )

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

;;

metrics_port)

		portarray=(`ps -ef | egrep -o 'flume.monitoring.port=[0-9]+' | egrep -o '[0-9]+'`)
		length=${#portarray[@]}
		printf "{"
		printf "\"data\":["

		for ((i=0; i<$length;i++))
			do 
			printf "{\"{#FLUME_SOURCE_PORT}\":\"${portarray[$i]}\"}"
			if [ $i -lt $[$length-1] ]; then
				printf ','
			fi
			done

		printf "]"
		printf "}"

;;