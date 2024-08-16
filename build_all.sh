#!/bin/sh

JAILS="$(cat jails)"
PORTS_FILE=${PORTS_FILE:-./my_ports}

for jail in $JAILS
do
	sudo poudriere bulk -C -j $jail -b release -f $PORTS_FILE
done
