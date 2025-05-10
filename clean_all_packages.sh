#!/bin/sh

handle_sigint() {
    echo "Caught SIGINT (Ctrl-C), exiting."
    exit 1
}
trap handle_sigint INT

JAILS="$(cat jails)"

for jail in $JAILS
do
	sudo poudriere pkgclean -A -j $jail -y
	sudo poudriere logclean -j $jail -y -a
	sudo poudriere distclean -y
done
