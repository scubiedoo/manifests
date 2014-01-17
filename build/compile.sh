#!/bin/bash
export VAGRANT_PROVISION=1
STARTDIR=`pwd`
SRCDIR="/vagrant"
cd ${SRCDIR}
source "$SRCDIR/build.api.sh"

# config parameter
#
MAKE="make -j 4"
KERNEL_MENUCONFIG=1

declare -A ROOTFS_IMAGE
ROOTFS_IMAGE[FILE]="/vagrant/vm/rootfs.img"
ROOTFS_IMAGE[SIZE]="4G"
ROOTFS_IMAGE[DIR]="/mnt/image_rootfs"
ROOTFS_IMAGE[FS]="ext4"
ROOTFS_IMAGE[FS_OPTS]="-F"

declare -A BOOTFS_IMAGE
BOOTFS_IMAGE[FILE]="/vagrant/vm/bootfs.img"
BOOTFS_IMAGE[SIZE]="16M"
BOOTFS_IMAGE[DIR]="/mnt/image_boot"
BOOTFS_IMAGE[FS]="vfat"

ROOTFS_DISTRO="precise"

# read configuration file
#
CONFIGFILE="$SRCDIR/build/compile.config.sh"
success chmod a+x ${CONFIGFILE}
eval `$CONFIGFILE`

#
# function definitions
#
function build_uboot()
{
	cd u-boot-sunxi
	success "CROSS_COMPILE=arm-linux-gnueabihf- $MAKE cubieboard2 2>&1 > uboot.log"
}

function build_kernel()
{
	build_ok building kernel
	cd linux-sunxi
	if [ ${KERNEL_MENUCONFIG} = 1 ]; then
		build_ok menuconfig enabled
		make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
	fi
	success "${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- uImage 2>&1 > kernel.log"
	success "${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules 2>&1 >> kernel.log"
	success "${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=output modules_install 2>&1 >> kernel.log"
}

function create_image()
{
	# ugly hack... pass the associative arry to the function
	# we create a string... then strip off the part "variablename="
	# this naked array is then reassigned to the new variablename
	# any other idea?
	local str opt
	str=$(declare -p $1)
	eval "declare -A opt=${str#*=}"

	local image size fs
	image=${opt[FILE]}
	size=${opt[SIZE]}
	fs=${opt[FS]}
	fs_opts=${opt[FS_OPTS]}
	
	# check existance of image file or create it
	#
	execute [ -r ${image} ] || { 
		success dd if=/dev/zero of=${image} bs=1 seek=${size} count=1; 
	}
	
	str=`blkid -o value -s TYPE ${image}`
	execute [ "x${str}" = "x${fs}" ] || {
		# Filesystem
		success sudo mkfs.${fs} ${fs_opts} ${image} || { execute rm -f ${image}; exit 1; }
	}
}

function prepare_image
{
	build_ok preparing image
	local str opt
	str=$(declare -p $1)
	eval "declare -A opt=${str#*=}"

	success sudo mkdir -p ${opt[DIR]}
	success create_image $1
	execute mountpoint ${opt[DIR]} || {
		success sudo mount ${opt[FILE]} ${opt[DIR]}
	}
}

function build_rootfs()
{
	build_ok building rootfs
	local distro rootfs
	distro="$1"
	rootfs="$2"
	
	success sudo debootstrap --verbose --arch=armhf --foreign ${distro} ${rootfs}
	success sudo cp /usr/bin/qemu-arm-static ${rootfs}/usr/bin/
	success sudo chroot ${rootfs}
	success sudo /debootstrap/debootstrap --verbose --second-stage
	exit
}

function setup_rootfs()
{
	build_info setup_rootfs
}

function assemble_imgage
{
	build_info assemble image
	# reference: http://linux-sunxi.org/Bootable_SD_card
#	success dd if=/dev/zero of=${image} bs=1M count=1 conv=notrunc

	#Partition
#	success sudo parted -s ${image} mklabel msdos
#	success sudo parted -s ${image} unit MB mkpart primary fat32 -- 1 16
#	success sudo parted -s ${image} unit MB mkpart primary ext4 -- 16 -2

	#Bootloader
#	success dd if=u-boot-sunxi/u-boot-sunxi-with-spl.bin of=${image} bs=1024 seek=8 conv=notrunc
}

#
# main part
#
success mkdir -p $BUILDDIR
cd $BUILDDIR
#success build_uboot

cd $BUILDDIR
#success build_kernel

cd $BUILDDIR
success prepare_image BOOTFS_IMAGE
success prepare_image ROOTFS_IMAGE

cd $BUILDDIR
success build_rootfs ${ROOTFS_DISTRO} ${ROOTFS_IMAGE[DIR]}

success setup_rootfs

success assemble_imgage

