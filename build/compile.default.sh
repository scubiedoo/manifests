#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

build_set MAKE "make -j 4"

echo "declare -A BOOTFS_IMAGE"
build_set BOOTFS_IMAGE[FILE] "/vagrant/vm/bootfs.img"
build_set BOOTFS_IMAGE[SIZE] "16M"
build_set BOOTFS_IMAGE[DIR] "/mnt/image_boot"
build_set BOOTFS_IMAGE[FS] "vfat"

echo "declare -A ROOTFS_IMAGE"
build_set ROOTFS_IMAGE[FILE] "/vagrant/vm/rootfs.img"
build_set ROOTFS_IMAGE[SIZE] "4G"
build_set ROOTFS_IMAGE[DIR] "/mnt/image_rootfs"
build_set ROOTFS_IMAGE[FS] "ext4"
build_set ROOTFS_IMAGE[FS_OPTS] "-F"

