#!/bin/bash
export VAGRANT_PROVISION=1
STARTDIR=`pwd`
SRCDIR="/vagrant"
cd $SRCDIR
source "$SRCDIR/build.api.sh"

# config parameter
#
MAKE="make -j 4"
KERNEL_MENUCONFIG=0

# read configuration file
#
CONFIGFILE="$SRCDIR/build/compile.config.sh"
success chmod a+x $CONFIGFILE
eval `$CONFIGFILE`
function build_uboot()
{
	cd u-boot-sunxi
	success "CROSS_COMPILE=arm-linux-gnueabihf- $MAKE cubieboard2 2>&1 > uboot.log"
}

function build_kernel()
{
	build_ok building kernel
	cd linux-sunxi
	if [ $KERNEL_MENUCONFIG = 1 ]; then
		build_ok menuconfig enabled
		make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
	fi
	success "${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- uImage 2>&1 > kernel.log"
	success "${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules 2>&1 >> kernel.log"
	success "${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=output modules_install 2>&1 >> kernel.log"
}

function build_rootfs()
{
	build_ok rootfs
}
echo $BUILDDIR
success mkdir -p $BUILDDIR
cd $BUILDDIR
build_uboot

cd $BUILDDIR
build_kernel

cd $BUILDDIR
build_rootfs
