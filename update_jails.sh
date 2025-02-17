#!/bin/sh
# Update RELEASE versions, delete and re-create CURRENT versions

handle_sigint() {
    echo "Caught SIGINT (Ctrl-C), exiting."
    exit 1
}
trap handle_sigint INT

JAILS="$(cat jails)"

for jail in $JAILS
do
	sudo poudriere jail -k -j $jail
	if echo $jail | grep -q cur
	then
		major="${jail%?cur*}"
		minor="${jail#??}"
		minor="${minor%%cur*}"
		release="${major}.${minor}-CURRENT"
    if [ "$variable" == *i386 ]
    then 
      JAILARCH='- a i386'
    else
      JAILARCH=''
    fi
		if poudriere jail -l | grep -qw "$jail"; then
			sudo poudriere jail -d -j $jail -y
		fi
		sudo poudriere jail -c $JAILARCH -j $jail -v $release
	else
		sudo poudriere jail -u -j $jail
	fi
done
