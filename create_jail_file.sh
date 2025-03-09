#!/bin/sh
rm -f jails
for version in $(cat jail-versions)
do
	for architecture in $(cat jail-architectures)
	do
		echo $version-$architecture >> jails
	done
done
