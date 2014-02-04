#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

build_set IMAGE "/vagrant/generated.img"
# i need to create it in the tmp-directory because one of mkfs/kpartx/losetup couldn't handle the file to be on a vboxsf file system for writing data to it :/
build_set TMPIMAGE "/tmp/generated.img"
