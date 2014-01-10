#!/bin/bash
VAGRANT_PROVISION=1

STARTDIR=`pwd`
SRCDIR="/vagrant"
cd $SRCDIR
source "$SRCDIR/build.api.sh"

# read configuration file
#
CONFIGFILE="$SRCDIR/prepare/prepareEnvironment.config.sh"
success chmod a+x $CONFIGFILE
eval `$CONFIGFILE`

#
#
function prepareDisk()
{
	local disk diskname
	local cnt
	disk="$1"
	diskname=`basename $disk`
	# check partition: we expect two sdb and sdb1
	#
	# in case this is our first run, the disk will be empty
	# this means /proc/partitions only contains one entry: sdb
	cnt=`ls ${disk}* |wc -l`
	[ $? = 0 ] || build_err "checking partition sdb failed" ;
	if [ $cnt = 0 ]; then
		build_err "disk $diskname not found";
	elif [ $cnt = 1 ]; then
		build_out "creating new partition table for $disk"
		[ -w $disk ] || build_err "$disk is not writeable"
		
		success [ -r $SRCDIR/prepare/cubiedisk.partition ]
		success sfdisk $disk -O $SRCDIR/$diskname.partition
		success sfdisk $disk -I $SRCDIR/prepare/cubiedisk.partition
	elif [ $cnt = 2 ]; then
		build_out "found disks"
	else
		build_err "disk $disk doesn't match the expected partition layout with exactly one partition";
	fi
}

success mkdir -p /mnt/builddisk
prepareDisk /dev/sdb
