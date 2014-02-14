#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

build_set KERNEL_GIT "https://github.com/patrickhwood/linux-sunxi"
build_set KERNEL_GIT_BRANCH "pat-3.4.79"

build_set KERNEL_MENUCONFIG 0
