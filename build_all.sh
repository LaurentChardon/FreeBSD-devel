#!/bin/sh

JAILS="$(cat jails)"
PORTS_FILE=${1:-./my_ports}

for jail in $JAILS
do
	sudo script -q build_all-$jail.log nice -n 10 poudriere -A bulk -j $jail -C -b latest -f $PORTS_FILE 2>&1 
done
