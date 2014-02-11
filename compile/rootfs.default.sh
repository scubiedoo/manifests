#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

build_set ROOTFS_SOURCE "http://cdimage.ubuntu.com/ubuntu-core/releases/raring/release/ubuntu-core-13.04-core-armhf.tar.gz"
build_set ROOTFS_FILE "$SRCDIR/vm/ubuntu-core-13.04-core-armhf.tar.gz"

build_set ROOTFS_DIR "$1"
build_set ROOTFS_INTERACTIVE 0
build_set ROOTFS_SCRIPTS "\
	adduser.sh \
	apt-update.sh \
	locales.sh \
	"
