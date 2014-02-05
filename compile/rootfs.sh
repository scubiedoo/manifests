#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

build_ok invoked $0
eval "`load_configuration \"${ROOTFS_REF[DIR]}\"`"

function setupChroot()
{
	local rootfs last_dir
	rootfs="$1"
	last_dir=`pwd`
	shift
	
	success cd ${rootfs}
	trap_push "cd ${last_dir}"
		success sudo mv ${rootfs}/etc/resolv.conf ${rootfs}/etc/resolv.conf.orig
		trap_push "sudo mv ${rootfs}/etc/resolv.conf.orig ${rootfs}/etc/resolv.conf"
			success sudo cp /etc/resolv.conf ${rootfs}/etc/resolv.conf
			
			success sudo mount -o bind /proc ${rootfs}/proc
			trap_push "sudo umount ${rootfs}/proc"
				success sudo mount -o bind /dev ${rootfs}/dev
				trap_push "sudo umount ${rootfs}/dev"
					success sudo mount -o bind /dev/pts ${rootfs}/dev/pts
					trap_push "sudo umount ${rootfs}/dev/pts"
						success sudo mount -o bind /sys ${rootfs}/sys
						trap_push "sudo umount ${rootfs}/sys"
							# now we can actually chroot :D
							for script in $@; do
								execute sudo chroot ${rootfs} [ -r /root/setup/${script} ] && {
									success sudo chmod a+x ${rootfs}/root/setup/${script} ;
									success sudo chroot ${rootfs} /root/setup/${script} ;
								}
							done
						trap_pop
					trap_pop
				trap_pop
			trap_pop
		trap_pop
	trap_pop
}

function build_rootfs()
{
	build_ok building rootfs $1

	local rootfs
	rootfs="$1"
	
	# we nee the -E flag to pass through http_proxy
	success "[ -r ${ROOTFS_FILE} ] || wget -O ${ROOTFS_REF} ${ROOTFS_SOURCE};"
	cd ${rootfs}
	success sudo tar xzf ${ROOTFS_FILE}
	success sudo cp /usr/bin/qemu-arm-static ${rootfs}/usr/bin/
	
	build_ok built rootfs $1
}

#
# i am totally unsure whether this is the right place...
# maybe we should move this function to assemble.sh??
# i might be moved to kernel.sh too... any ideas?!
#
function copy_kernel_modules()
{
	local rootfs
	rootfs="$1"

	success sudo mkdir -p ${rootfs}/lib/modules
	success sudo rm -rf ${rootfs}/lib/modules/
	success sudo cp -vr linux-sunxi/output/lib ${rootfs}
}

function setup_rootfs()
{
	build_ok setting up rootfs $1
	
	local rootfs
	rootfs="$1"
	
	success sudo mkdir -p ${rootfs}/root/setup
	success sudo cp -a ${SRCDIR}/setup/* ${rootfs}/root/setup
	success setupChroot ${rootfs} ${ROOTFS_SCRIPTS}
	
	if [ ${ROOTFS_INTERACTIVE} = 1 ]; then
		success setupChroot ${rootfs} interactive.sh
	fi

	build_ok setting up rootfs $1
}

cd ${BUILDDIR}
success build_rootfs ${ROOTFS_DIR}

cd ${BUILDDIR}
success copy_kernel_modules ${ROOTFS_DIR}

cd ${BUILDDIR}
success setup_rootfs ${ROOTFS_DIR}
