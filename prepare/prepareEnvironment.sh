#!/bin/bash

# see build.sh for idea of this line
#
ls `dirname $0`/build.api.sh &> /dev/null || { echo "restarting command: $@" ; exec /vagrant/prepare/prepareEnvironment.sh $@; exit $?; }

# START
#
export VAGRANT_PROVISION=1

STARTDIR=`pwd`
SRCDIR="/vagrant"
cd $SRCDIR
source "$SRCDIR/build.api.sh"

eval `load_configuration`

#
#
function createDisk()
{
	local disk
	disk=$1
	# remember: blocksize=1K * seek=10M => 10GB disksize
	success dd if=/dev/zero of=$disk  bs=1K seek=10M count=1
	# we create ext2 because ignore journalling and stuff
	success mkfs.ext2 -F $disk
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
		success mkdir -p $mountpoint
			
		device=`losetup -f`
		RET=$?
		success "[ -n $device ] || echo 'no more loop devices'"
		success	losetup $device $disk
		success mount -t ext2 $device $mountpoint
	fi
}

# i want to use an extra image file in order to have the possibility to run vagrant destroy and recreate my image.
# but i don't want to lose my compiled files and images
# 
prepareDisk /vagrant/vm/builddisk.img $BUILDDIR
success mkdir -p $BUILDDIR/vagrant
chown vagrant $BUILDDIR/vagrant