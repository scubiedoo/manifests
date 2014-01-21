#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

eval "`load_configuration $@`"

function calc_needed_size()
{
	local additional_size rootdir size
	additional_size=`units --compact ${1}iB B |head -n 1`
	rootdir=$2
	size=`df ${rootdir} |grep "${rootdir}" | sed -n 2p | awk '{print $3}'`
	[ $? = 0 && -n "$size" ] || { return 1; }
	
	# might be better to have some more space for writing
	echo "${size} + ${additional_size} + ( 100 * 1024 * 1024 )" |bc
}

function assemble_image
{
	build_ok assembling image
	# reference: http://linux-sunxi.org/Bootable_SD_card
	success rm -f ${IMAGE} ;
	
	local real_size
	real_size=`calc_needed_size ${BOOTFS_REF[SIZE]} ${ROOTFS_REF[DIR]}`
	success dd if=/dev/zero of=${IMAGE} bs=1 count=${real_size}
	
	# Clean first 1M
	success dd if=/dev/zero of=${IMAGE} bs=1M count=1 conv=notrunc

	# TODO we have 16M fixed size... better add some more flexibility?
	#Partition
	success sudo parted -s ${IMAGE} mklabel msdos
	success sudo parted -s ${IMAGE} unit MB mkpart primary fat32 -- 1 16
	success sudo parted -s ${IMAGE} unit MB mkpart primary ext4 -- 16 -2

	#Bootloader
	success sudo dd if=u-boot-sunxi/u-boot-sunxi-with-spl.bin of=${IMAGE} bs=1024 seek=8 conv=notrunc
	
	#Boot partition
	success sudo dd if=${BOOTFS_REF[FILE]} of=${IMAGE} bs=1024 seek=1M conv=notrunc
	
	#Rootfs partition
	#
	# totally unsure whether this is a good idea...
	#
	# the imagefile contains all partition: 
	# i mount the new (smaller) rootfs to a directory
	# then i tar the reference rootfs (which contains all data)
	#   -- i tar it because i dont trust cp or rsync... we might give that a try to --
	# i extract the tar file to my smaller rootfs... which should be big enough to hold all data
	# that's it
	local image_dir temp_file
	image_dir="/mnt/rootfs_image"
	success sudo mkdir -p 
	success sudo mount ${IMAGE} ${image_dir} -o offset=16M
	
	temp_file="/vagrant/vm/rootfs_image.tar"
	cd ${ROOTFS_REF[DIR]}
	success sudo tar -c --exclude='dev/*' -f ${temp_file} .
	
	cd ${image_dir}
	success sudo tar -xf ${temp_file}
	success sudo umount ${image_dir}

	# that's it i guess?!

	build_ok assembled image
}

cd ${BUILDDIR}
success assemble_image
