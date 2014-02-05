#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

build_info running `basename ${BASH_ARGV[0]}`
eval "`load_configuration $@`"

#
# function definitions
#
function build_uboot()
{
	build_ok building uboot
	cd u-boot-sunxi
	success "CROSS_COMPILE=arm-linux-gnueabihf- $MAKE cubieboard2 2>&1 > uboot.log"
	build_ok built uboot
}

cd ${BUILDDIR}
success sync_git "u-boot-sunxi" ${UBOOT_GIT} ${UBOOT_GIT_BRANCH}

cd ${BUILDDIR}
success build_uboot
