#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

# config parameter
#
build_export MENUCONFIG_SVN "http://menuconfig.googlecode.com/svn/trunk/"
build_export CUBIECONFIG 0
build_export KBUILD_DEFCONFIG "$SRCDIR/config/cb2_defconfig"
build_export MENUCONFIG_FILES "\
	$SRCDIR/config/environment.in \
	$SRCDIR/config/cubieboard.in \
	$SRCDIR/config/kernel.in \
	$SRCDIR/config/example.in \
	"
