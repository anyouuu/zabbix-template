#!/bin/bash
#pid_str=$(ps -ef | grep 'org.apache.flume.node.Application ' | grep -v 'color=auto' | awk '{print $2}' | tr -t '\n' '|' | sed 's/.$//')
#post_str=$(netstat -tunlp | egrep "$pid_str" | awk '{print $4}'| awk -F ":" '{print $NF}'| tr '\n' ' ')

port_str=$(ps -ef | egrep -o 'flume.monitoring.port=[0-9]+' | egrep -o '[0-9]+' | tr -t '\n' ' ')

pwd=$(cd `dirname $0`; pwd)
if [ "$1" = "discover" ]; then
        ${pwd}/get_flume_info.py --discover $2 --ports $port_str
elif [ "$1" = "check" ]; then
        ${pwd}/get_flume_info.py --check $2 $3 --ports $port_str
else
        ${pwd}/get_flume_info.py --diff $2 $3 $4 --ports $port_str
fi