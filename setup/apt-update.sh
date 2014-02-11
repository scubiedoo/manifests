#!/bin/bash

# +600 means 600 min => 10h between update... to improve build speed
if [ ! -e /root/.lastupdate ] || [ -n "`find /root/.lastupdate -mmin +600 2> /dev/null`" ]; then
	success apt-get update
	success apt-get -y upgrade
	success apt-get -y clean
	success apt-get -y autoremove
	success touch /root/.lastupdate
fi

success apt-get install -y ${SETUP_PACKAGES}