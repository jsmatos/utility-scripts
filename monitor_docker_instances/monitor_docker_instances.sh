#!/bin/bash

# 
#
#
#
#

SELF_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo ${SELF_DIR}


function text {
	if [[ $# -eq 0 ]]
	then
		echo "<txt></txt>"
	else
		echo "<txt>$@</txt>"
	fi
}

function tooltip {
	if [[ $# -eq 0 ]]
	then
		echo "<tool></tool>"
	else
		echo "<tool>$1</tool>"
	fi
}

function click {
	if [[ $# -gt 0 ]]
	then
		echo "<click>$@</click>"
	fi
}

function icon {
	if [[ $# -gt 0 ]]
	then
		echo "<img>$@</img>"
	fi
}

function warn {
	icon "${SELF_DIR}/alert-triangle-red-16.png"
}

docker_state=$(systemctl show --property ActiveState docker | grep "ActiveState=active")

if [ "x${docker_state}" != "xActiveState=active" ]
then
	tooltip "docker service is stoped, click to start"
	click "pkexec systemctl start docker"
	warn
	exit 0
fi

number_of_instances=$(docker ps -q | wc -l)

if [ ${number_of_instances} -eq 0 ]
then
	tooltip "dnsdock is not running, click to start"
	click "pkexec systemctl start docker"
	warn
	exit 0
fi

instance_names=$(docker ps --format '{{.Names}}')
tooltip "${number_of_instances} docker instances running

${instance_names}"
icon "${SELF_DIR}/check-circle-green-16.png"
click

