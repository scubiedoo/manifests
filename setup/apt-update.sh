#!/bin/bash

if [ ! -e /root/.lastupdate ] || [ -n "`find /root/.lastupdate -mmin +60 2> /dev/null`" ]; then
	success apt-get update
	success apt-get -y upgrade
	success apt-get -y clean
	success apt-get -y autoremove
	success touch /root/.lastupdate
fi
