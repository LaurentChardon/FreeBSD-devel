#!/bin/sh

JAILS="140rel 132rel"
PORTS_FILE=./my_ports

for jail in $JAILS
do
	sudo poudriere bulk -j $jail -b release -f $PORTS_FILE
done
