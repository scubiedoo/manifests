#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

# TODO find a way to integrate with menuconfig...?!
build_set ROOTFS_SCRIPTS "\
	adduser.sh \
	apt-update.sh \
	miniand_com.sh \
	"
