#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

build_set KERNEL_GIT "https://github.com/patrickhwood/linux-sunxi"
build_set KERNEL_GIT_BRANCH "pat-3.4.75"

build_set KERNEL_MENUCONFIG 1
