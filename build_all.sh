#!/bin/sh

JAILS="$(cat jails)"
PORTS_FILE=./my_ports

for jail in $JAILS
do
	sudo poudriere bulk -k -j $jail -b release -f $PORTS_FILE 2>&1 | tee build-$jail.log
done
