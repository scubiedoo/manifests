#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

eval "`load_configuration $@`"

function calc_needed_size()
{
	local additional_size rootdir size
	additional_size=`units --compact ${1}iB B |head -n 1`
	rootdir=$2
	size=`df ${rootdir} |grep "${rootdir}" | awk '{print \$3}'`
	[ $? = 0 -a -n "$size" ] || { return 1; }
	
	# might be better to have some more space for writing
	local extra_space=100
	echo "( ${size} + ${additional_size} + ( ${extra_space} * 1024 * 1024 ) ) / 1024" |bc
}

function assemble_image
{
	build_ok assembling image
	# reference: http://linux-sunxi.org/Bootable_SD_card
	
	success rm -f ${TMPIMAGE} ;
	
	local rootfs_size
	rootfs_size=
	real_size=`calc_needed_size ${BOOTFS_REF[SIZE]} ${ROOTFS_REF[DIR]}`
	success "[ $? = 0 ] || { echo \"failed to calc_needed_size\" ; exit 1; }"

	# Create clean container
	success dd if=/dev/zero of=${TMPIMAGE} bs=1024 seek=${real_size} count=1
	
	#Partition
	success sudo parted -s ${TMPIMAGE} mklabel msdos
	success sudo parted -s ${TMPIMAGE} unit MB mkpart primary fat32 -- 1 16
	success sudo parted -s ${TMPIMAGE} unit MB mkpart primary ext4 -- 16 -2

	#Bootloader
	success sudo dd if=u-boot-sunxi/u-boot-sunxi-with-spl.bin of=${TMPIMAGE} bs=1024 seek=8 conv=notrunc
	
	#Boot partition
	# remember: bs=1024 => seek to position 1M = 1K*1024
	success sudo dd if=${BOOTFS_REF[FILE]} of=${TMPIMAGE} bs=1024 seek=1K conv=notrunc

	#Rootfs partition
	#
	# totally unsure whether this is a good idea...
	#
	# the imagefile contains all partitions: 
	# i mount the new (smaller) rootfs to a directory
	# then i tar the reference rootfs (which contains all data)
	#   -- i tar it because i dont trust cp or rsync... we might give that a try --
	# i extract the tar file to my smaller rootfs... which should be big enough to hold all data
	# that's it
	local RET
	success sudo kpartx -s -a ${TMPIMAGE}
	trap_push "sleep 1;sudo kpartx -s -d ${TMPIMAGE}"
		local image_dir
		image_dir="/mnt/rootfs_image"
		success sudo mkdir -p ${image_dir}
		
		# output of kpartx looks like this
		# i need the chosen loop-device name used in /dev/mapper
		#sudo kpartx -l /tmp/file.img
		#loop3p1 : 0 28672 /dev/loop3 2048
		#loop3p2 : 0 200704 /dev/loop3 30720
		local device
		device="/dev/mapper/`sudo kpartx -l ${TMPIMAGE} |cut -d' ' -f 1 |grep p2`"
		success sudo mkfs.${ROOTFS_REF[FS]} ${ROOTFS_REF[FS_OPTS]} ${device}
		success sudo mount ${device} ${image_dir}
		trap_push "cd ${BUILDDIR};sudo umount ${image_dir}"
			local temp_file
			temp_file="/vagrant/vm/rootfs_image.tar"
			success cd ${ROOTFS_REF[DIR]}
			success sudo tar -c --exclude='dev/*' -f ${temp_file} .
		
			success cd ${image_dir}
			success sudo tar -xf ${temp_file}
		trap_pop
	trap_pop
	
	# that's it i guess?!
	success rm -f ${IMAGE}
	success mv ${TMPIMAGE} ${IMAGE}
	
	build_ok assembled image
}

cd ${BUILDDIR}
success assemble_image
