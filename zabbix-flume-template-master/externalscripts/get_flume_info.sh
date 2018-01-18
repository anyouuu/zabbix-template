#!/bin/bash

port_str=$(ps -ef | egrep -o 'flume.monitoring.port=[0-9]+' | egrep -o '[0-9]+' | tr -t '\n' ' ')

if [ "$1" = "discover" ]; then
	/usr/lib/zabbix/externalscripts/get_flume_info.py --discover $2 --ports $port_str
elif [ "$1" = "check" ]; then
	/usr/lib/zabbix/externalscripts/get_flume_info.py --check $2 $3 --ports $port_str
else
	/usr/lib/zabbix/externalscripts/get_flume_info.py --diff $2 $3 $4 --ports $port_str
fi
