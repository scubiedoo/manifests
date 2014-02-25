#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

# remember: we run configuration files in a new shell and .config is not exported
source $SRCDIR/.config

build_set MAKE "make -j 4"
build_set DEFAULT_TARGETS "uboot boot.scr kernel rootfs \
	${CONFIG_XBMC_TARGET} \
	assemble"

echo "declare -A BOOTFS_REF"
build_set BOOTFS_REF[FILE] "${CONFIG_BOOTFS_REF_FILE}"
build_set BOOTFS_REF[SIZE] "${CONFIG_BOOTFS_REF_SIZE}"
build_set BOOTFS_REF[DIR] "${CONFIG_BOOTFS_REF_DIR}"
build_set BOOTFS_REF[FS] "${CONFIG_BOOTFS_REF_FS}"
build_set BOOTFS_REF[FS_OPTS] "${CONFIG_BOOTFS_REF_FS_OPTS}"

echo "declare -A ROOTFS_REF"
build_set ROOTFS_REF[FILE] "${CONFIG_ROOTFS_REF_FILE}"
build_set ROOTFS_REF[SIZE] "${CONFIG_ROOTFS_REF_SIZE}"
build_set ROOTFS_REF[DIR] "${CONFIG_ROOTFS_REF_DIR}"
build_set ROOTFS_REF[FS] "${CONFIG_ROOTFS_REF_FS}"
build_set ROOTFS_REF[FS_OPTS] "${CONFIG_ROOTFS_REF_FS_OPTS}"

