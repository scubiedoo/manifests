#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

build_info running `basename ${BASH_ARGV[0]}`

function build_kernel()
{
	build_ok building kernel
	cd linux-sunxi
	if [ "${CONFIG_KERNEL_MENUCONFIG}" = "y" ]; then
		build_ok menuconfig enabled
		${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
		# TODO remove this line if no longer necessary
		# it's a hack because of the broken kernel config
		success sed -i -e's/^CONFIG_HWMON=m$/CONFIG_HWMON=y/' .config
	fi
	success "${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- uImage > kernel.log 2>&1"
	success "${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules >> kernel.log 2>&1"
	success "${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=output modules_install >> kernel.log 2>&1"
	build_ok built kernel
}

function deploy_kernel()
{
	build_ok deploying kernel
	success sudo cp -f linux-sunxi/arch/arm/boot/uImage ${BOOTFS_REF[DIR]}
	build_ok kernel deployed
}

cd ${BUILDDIR}
success sync_git "linux-sunxi" ${CONFIG_KERNEL_GIT} ${CONFIG_KERNEL_GIT_BRANCH}
success "[ -r linux-sunxi/.config ] || { cd linux-sunxi; make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- ${CONFIG_KERNEL_DEFCONFIG} ; }"

cd ${BUILDDIR}
success build_kernel

cd ${BUILDDIR}
success deploy_kernel
