#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

eval "`load_configuration $@`"

function get_kernel()
{
	build_ok getting kernel
	success "[ -d linux-sunxi ] || git clone ${KERNEL_GIT}"
	cd linux-sunxi
	success git checkout ${KERNEL_GIT_BRANCH}
	success "[ -r .config ] || make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- sun7i_defconfig"
	build_ok got kernel
}

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

cd ${BUILDDIR}
success get_kernel

cd ${BUILDDIR}
success build_kernel
