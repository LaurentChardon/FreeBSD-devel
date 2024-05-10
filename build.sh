#!/bin/sh

if [ "$#" -ne 1 ]
then
	echo "Usage: $(basename $0) category/port"
	exit 1
fi

JAILS="$(cat jails)"
PORT=$1

for jail in $JAILS
do
	sudo poudriere testport -k -j $jail -b release $PORT 2>&1 | tee build-$jail.log
done
