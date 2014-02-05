#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

eval "`load_configuration $@`"

function build_kernel()
{
	build_ok building kernel
	cd linux-sunxi
	if [ ${KERNEL_MENUCONFIG} = 1 ]; then
		build_ok menuconfig enabled
		${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
	fi
	success "${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- uImage 2>&1 > kernel.log"
	success "${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules 2>&1 >> kernel.log"
	success "${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=output modules_install 2>&1 >> kernel.log"
	build_ok built kernel
}

function deploy_kernel()
{
	build_ok deploying kernel
	success sudo cp -f linux-sunxi/arch/arm/boot/uImage ${BOOTFS_REF[DIR]}
	build_ok kernel deployed
}

cd ${BUILDDIR}
success sync_git "linux-sunxi" ${KERNEL_GIT} ${KERNEL_GIT_BRANCH}
success "[ -r linux-sunxi/.config ] || { cd linux-sunxi; make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- sun7i_defconfig ; }"

cd ${BUILDDIR}
success build_kernel

cd ${BUILDDIR}
success deploy_kernel
