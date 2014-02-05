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

function build_uenv()
{
	build_ok building uEnv.txt
	if [ -r compile/uEnv.txt ]; then
		success sudo cp -f ${SRCDIR}/compile/uEnv.txt ${BOOTFS_REF[DIR]}/uEnv.txt
	else
		success sudo cp -f ${SRCDIR}/compile/uEnv.default.txt ${BOOTFS_REF[DIR]}/uEnv.txt
	fi
	# TODO an interaction might be nice to ask for the user's config, like make menuconfig for the kernel
	# 
	build_ok built uEnv.txt
}

cd ${BUILDDIR}
success sync_git "u-boot-sunxi" ${UBOOT_GIT} ${UBOOT_GIT_BRANCH}

cd ${BUILDDIR}
success build_uboot

cd ${BUILDDIR}
success build_uenv
