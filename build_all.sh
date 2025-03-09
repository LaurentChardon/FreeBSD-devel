#!/bin/sh

JAILS="$(cat jails)"
PORTS_FILE=${1:-./my_ports}

for jail in $JAILS
do
	sudo poudriere bulk -C -j $jail -b release -f $PORTS_FILE
done
