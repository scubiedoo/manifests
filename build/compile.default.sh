#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

build_set MAKE "make -j 4"

echo "declare -A BOOTFS_REF"
build_set BOOTFS_REF[FILE] "/vagrant/vm/bootfs_reference.img"
build_set BOOTFS_REF[SIZE] "16M"
build_set BOOTFS_REF[DIR] "/mnt/bootfs_ref"
build_set BOOTFS_REF[FS] "vfat"

echo "declare -A ROOTFS_REF"
build_set ROOTFS_REF[FILE] "/vagrant/vm/rootfs_reference.img"
build_set ROOTFS_REF[SIZE] "4G"
build_set ROOTFS_REF[DIR] "/mnt/rootfs_ref"
build_set ROOTFS_REF[FS] "ext4"
build_set ROOTFS_REF[FS_OPTS] "-F"

