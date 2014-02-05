#!/bin/bash

if [ ! -e /root/.lastupdate ] || [ -n "`find /root/.lastupdate -mmin +60 2> /dev/null`" ]; then
	apt-get update || exit 1
	apt-get -y upgrade || exit 2
	apt-get -y clean || exit 3
	apt-get -y autoremove || exit 4
	touch /root/.lastupdate
fi
