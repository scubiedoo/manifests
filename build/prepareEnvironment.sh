#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

eval "`load_configuration`"

#
#
function createDisk()
{
	local disk
	disk=$1
	# remember: blocksize=1K * seek=10M => 10GB disksize
	success sudo dd if=/dev/zero of=$disk  bs=1K seek=10M count=1
	# we create ext2 because ignore journalling and stuff
	success sudo mkfs.ext2 -F $disk
}
#
#
function prepareDisk()
{
	local disk diskname mountppoint device RET
	disk="$1"
	mountpoint="$2"
	
	success "[ -r $disk ] || createDisk $disk"
	
	#disk already mounted...?! caused by "vagrant provision"
	device="`mount |grep \"$mountpoint\"`"
	RET=$?
	if [ $RET != 0 ]; then
		success sudo mkdir -p $mountpoint
			
		device=`sudo losetup -f`
		RET=$?
		success "[ -n $device ] || echo 'no more loop devices'"
		success	sudo losetup $device $disk
		success sudo mount -t ext2 $device $mountpoint
	fi
}

# i want to use an extra image file in order to have the possibility to run vagrant destroy and recreate my image.
# but i don't want to lose my compiled files and images
# 
prepareDisk $BUILDDISK `dirname $BUILDDIR`
success mkdir -p $BUILDDIR
chown vagrant $BUILDDIR
