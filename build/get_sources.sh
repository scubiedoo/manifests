#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

# config parameter
#

# read configuration file
#
CONFIGFILE="$SRCDIR/build/get_sources.config.sh"
success chmod a+x $CONFIGFILE
eval `$CONFIGFILE`
function get_uboot()
{
	success "[ -d u-boot-sunxi ] || git clone https://github.com/linux-sunxi/u-boot-sunxi"
	cd u-boot-sunxi
	success git checkout sunxi
}

function get_kernel()
{
	success "[ -d linux-sunxi ] || git clone https://github.com/patrickhwood/linux-sunxi"
	cd linux-sunxi
	success git checkout pat-3.4.75
	success "[ -r .config ] || make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- sun7i_defconfig"
}

function get_rootfs()
{
	build_out getting rootfs
}

success mkdir -p $BUILDDIR
cd $BUILDDIR
build_ok getting uboot
get_uboot

cd $BUILDDIR
build_ok getting kernel
success get_kernel

cd $BUILDDIR
build_ok getting rootfs
success get_rootfs
