#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

eval "`load_configuration $@`"

function configure()
{
	execute [ -d menuconfig ] || { success svn checkout ${MENUCONFIG_SVN} menuconfig; }
	trap_push "cd `pwd`"
		success cd menuconfig
		success svn update
		success make menuconfig
		success cp .config ..
	trap_pop
	source $SRCDIR/compile/.config
}
