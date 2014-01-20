#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

build_info running uboot.sh
eval "`load_configuration $@`"

function get_uboot()
{
	build_ok getting uboot
	success "[ -d u-boot-sunxi ] || git clone ${UBOOT_GIT}"
	cd u-boot-sunxi
	success git checkout ${UBOOT_GIT_BRANCH}
	build_ok got uboot
}

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
success get_uboot

cd ${BUILDDIR}
success build_uboot
