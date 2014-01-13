#!/bin/bash
export VAGRANT_PROVISION=1

STARTDIR=`pwd`
SRCDIR="/vagrant"
cd $SRCDIR
source "$SRCDIR/build.api.sh"

# read configuration file
#
CONFIGFILE="$SRCDIR/prepare/get_sources.config.sh"
success chmod a+x $CONFIGFILE
eval `$CONFIGFILE`

MAKE="make -j 4"
function get_uboot()
{
	cd ~/sources
	success git clone https://github.com/linux-sunxi/u-boot-sunxi
	cd u-boot-sunxi
	success git checkout sunxi
	success CROSS_COMPILE=arm-linux-gnueabihf- $MAKE cubieboard2
}

function get_kernel()
{
	build_ok building kernel
}

function get_rootfs()
{
	build_ok rootfs
}

cd ~/sources
get_uboot

cd ~/sources
get_kernel

cd ~/sources
get_rootfs
