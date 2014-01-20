#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

eval "`load_configuration $@`"

function assemble_image
{
	build_ok assembling image
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

cd ${BUILDDIR}
success assemble_image
