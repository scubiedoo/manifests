#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

eval "`load_configuration $@`"

function create_configfile()
{
	cat > Config.in << EOF
	source $SRCDIR/Config.in
EOF
}

function configure()
{
	execute [ -d menuconfig ] || { success svn checkout ${MENUCONFIG_SVN} menuconfig; }
	trap_push "cd `pwd`"
		success cd menuconfig
		success svn update
		success create_configfile
		success make menuconfig
		success cp .config $SRCDIR/.config
	trap_pop
}

cd $BUILDDIR
success "[ ${CUBIECONFIG} = 0 ] || configure"
source $SRCDIR/.config
