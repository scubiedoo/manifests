#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

build_set UBOOT_GIT "https://github.com/linux-sunxi/u-boot-sunxi"
build_set UBOOT_GIT_BRANCH "sunxi"
