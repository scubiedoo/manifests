#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

# TODO find a way to integrate with menuconfig...?!
build_set ROOTFS_SCRIPTS "\
	adduser.sh \
	apt-update.sh \
	miniand_com.sh \
	"

build_export BUILD_CHROOT_SCRIPTS "\
	adduser.sh \
	setup-14.04.sh \
	apt-update.sh \
	xbmc-dependencies.sh \
	buildroot/xbmc.sh \
	"
