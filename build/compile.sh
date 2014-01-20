#!/bin/bash
export VAGRANT_PROVISION=1
STARTDIR=`pwd`
SRCDIR="/vagrant"
cd ${SRCDIR}
source "$SRCDIR/build.api.sh"

build_info running compile.sh
eval "`load_configuration $@`"

function create_image()
{
	build_ok creating image

	# ugly hack... pass the associative array to the function
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
	build_ok created image
}

function prepare_image
{
	build_ok preparing image
	
	# this part is commented in create_image
	local str opt
	str=$(declare -p $1)
	eval "declare -A opt=${str#*=}"

	success sudo mkdir -p ${opt[DIR]}
	success create_image $1
	execute mountpoint ${opt[DIR]} || {
		success sudo mount ${opt[FILE]} ${opt[DIR]}
	}
	build_ok prepared image
}

function assemble_imgage
{
	build_ok assemble image
	# reference: http://linux-sunxi.org/Bootable_SD_card
#	success dd if=/dev/zero of=${image} bs=1M count=1 conv=notrunc

	#Partition
#	success sudo parted -s ${image} mklabel msdos
#	success sudo parted -s ${image} unit MB mkpart primary fat32 -- 1 16
#	success sudo parted -s ${image} unit MB mkpart primary ext4 -- 16 -2

	#Bootloader
#	success dd if=u-boot-sunxi/u-boot-sunxi-with-spl.bin of=${image} bs=1024 seek=8 conv=notrunc
	build_ok assembled image
}

#
# main part
#
success mkdir -p $BUILDDIR
cd $BUILDDIR
#source ${SRCDIR}/build/uboot.sh

cd $BUILDDIR
#source ${SRCDIR}/build/kernel.sh

cd $BUILDDIR
success prepare_image BOOTFS_IMAGE
success prepare_image ROOTFS_IMAGE

cd $BUILDDIR
source ${SRCDIR}/build/rootfs.sh ${ROOTFS_IMAGE[DIR]}

success assemble_imgage

