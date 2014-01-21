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

#
# main part
#
success mkdir -p $BUILDDIR

cd $BUILDDIR
success prepare_image BOOTFS_REF
success prepare_image ROOTFS_REF
#
# we might use some advanced mechanism like getopt here
if [ "x$1" = "x" ]; then
	cd $BUILDDIR
	source ${SRCDIR}/build/uboot.sh

	cd $BUILDDIR
	source ${SRCDIR}/build/kernel.sh

	cd $BUILDDIR
	source ${SRCDIR}/build/rootfs.sh

	cd $BUILDDIR
	source ${SRCDIR}/build/assemble.sh
else
	while [ $# -gt 0 ]; do
		cd $BUILDDIR
		source ${SRCDIR}/build/$1.sh
		shift
	done
fi
