#!/bin/bash

check_disk() {

	USAGE=$(df -P  -h / | awk 'NR==2 {print $5}' | tr -d '%')

	if [ "$USAGE" -gt 80 ]; then
		echo "WARNING: Root disk usage is high at ${USAGE}%"
	else 
		echo "Disk: ${USAGE}% used"
	fi
}

check_cpu(){
	echo "Top 3 CPU Processes:"
	ps aux --sort=-%cpu | awk 'NR<=4 {print $1, $2, $3"%", $11}'
}

check_memory() {
	AVAILABLE_MEM=$(free -m | awk 'NR==2 {print $7}')
	
	if [ "$AVAILABLE_MEM" -lt 200 ]; then
		echo "WARNING: Available memory is critically low: ${AVAILABLE_MEM}MB"
	else 
		echo "Memory: ${AVAILABLE_MEM}MB available"
	fi
}

for i in {1..3}; do
	echo "===============================" >> monitor.log
	echo "System Check Run $i at $(date '+%Y-%m-%d %H:%M:%S')" >> monitor.log

	check_disk >> monitor.log
	check_cpu >> monitor.log
	check_memory >> monitor.log
	echo "===============================" >> monitor.log


	if [ "$i" -ne 3 ]; then
		sleep 5
	fi

done


echo "Monitoring complete. Check monitor.log for results."
