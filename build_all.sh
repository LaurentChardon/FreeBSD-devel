#!/bin/sh

JAILS="$(cat jails)"
PORTS_FILE=${1:-./my_ports}

for jail in $JAILS
do
	sudo nice poudriere -A bulk -C -j $jail -b release -f $PORTS_FILE 2>&1 | tee build_all-$jail.log
done
