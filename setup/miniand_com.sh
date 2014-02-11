#!/bin/bash

#
# these steps are taken from https://www.miniand.com/forums/forums/development--3/topics/ubuntu-12-10-linux-sunxi-3-4-24-kernel-image-and-build-from-scratch
#

function locales()
{
	success locale-gen ${SETUP_LOCALES}
	success update-locale ${SETUP_LOCALES}
}

function rc_local()
{
	# the sed command might look awkward: we check for "chmod 777...",
	# if we can't find it, we add it at the end of the file (right before "exit 0")
	# so, we replace "exit 0" with "chmod 777...<new line>exit 0"
	execute grep -Fq "\"chmod 777 /dev/ump\"" /etc/rc.local || {
		success sed -i -e "'s#^exit 0\$#chmod 777 /dev/ump\nexit 0#g'" /etc/rc.local ;
	}
	execute grep -Fq "\"chmod 777 /dev/mali\"" /etc/rc.local || {
		success sed -i "'s#^exit 0\$#chmod 777 /dev/mali\nexit 0#g'" /etc/rc.local ;
	}
}

locales
rc_local
