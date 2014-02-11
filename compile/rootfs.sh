#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

build_ok invoked $0
eval "`load_configuration`"

function build_rootfs()
{
	build_ok building rootfs $1

	local rootfs
	rootfs="${ROOTFS_REF[DIR]}"
	
	# we nee the -E flag to pass through http_proxy
	success "[ -r ${ROOTFS_FILE} ] || wget -O ${ROOTFS_REF} ${ROOTFS_SOURCE};"
	cd ${rootfs}
	success sudo tar xkzf ${ROOTFS_FILE}
	
	build_ok built rootfs $1
}

#
# i am totally unsure whether this is the right place...
# maybe we should move this function to assemble.sh??
# it might be moved to kernel.sh too... 
# e.g. when working on the kernel and running "manifests.sh kernel assemble", the kernel modules will not be copied to the rootfs
# or an own setup script...
# any ideas?!
#
function copy_kernel_modules()
{
	local rootfs
	rootfs="${ROOTFS_REF[DIR]}"

	success sudo mkdir -p ${rootfs}/lib/modules
	success sudo rm -rf ${rootfs}/lib/modules/
	success sudo cp -r linux-sunxi/output/lib ${rootfs}
	cat > /tmp/modules << EOF

EOF
	success "[ $? = 0 ] || { build_err \"failed to created /tmp/modules\" ; }"
	success "echo \"${KERNEL_BOOT_MODULES}\" >> /tmp/modules"
	success sudo cp /tmp/modules ${rootfs}/etc/modules
}

#
# this is kinda ugly... the functions are linked together, but it seems to be too much code to be in one function
function prepare_chroot()
{
	success cd ${rootfs}
	trap_push "cd ${last_dir}"

	success sudo cp /etc/apt/apt.conf.d/01proxy ${rootfs}/etc/apt/apt.conf.d/01proxy-chroot
	trap_push "sudo rm ${rootfs}/etc/apt/apt.conf.d/01proxy-chroot"

	success sudo mv ${rootfs}/etc/resolv.conf ${rootfs}/etc/resolv.conf.chroot
	trap_push "sudo mv ${rootfs}/etc/resolv.conf.chroot ${rootfs}/etc/resolv.conf"
	success sudo cp /etc/resolv.conf ${rootfs}/etc/resolv.conf
	
	success sudo mount -o bind /proc ${rootfs}/proc
	trap_push "sudo umount ${rootfs}/proc"

	success sudo mount -o bind /dev ${rootfs}/dev
	trap_push "sudo umount ${rootfs}/dev"

	success sudo mount -o bind /dev/pts ${rootfs}/dev/pts
	trap_push "sudo umount ${rootfs}/dev/pts"

	success sudo mount -o bind /sys ${rootfs}/sys
	trap_push "sudo umount ${rootfs}/sys"

	success sudo mkdir -p ${rootfs}/vagrant
	success sudo mount -o bind /vagrant ${rootfs}/vagrant
	trap_push "sudo umount ${rootfs}/vagrant"
	
	success sudo cp /usr/bin/qemu-arm-static ${rootfs}/usr/bin/
	trap_push "sudo rm -f ${rootfs}/usr/bin/qemu-arm-static"
	
}

function cleanup_chroot()
{
	trap_pop
	trap_pop
	trap_pop
	trap_pop
	trap_pop
	trap_pop
	trap_pop
}

function setupChroot()
{
	local rootfs last_dir
	rootfs="${ROOTFS_REF[DIR]}"
	last_dir=`pwd`
	
	prepare_chroot
	# now we can actually chroot :D
	for script in $@; do
		execute sudo [ -r ${rootfs}/root/setup/${script} ] && {
			success sudo chroot ${rootfs} su - -c "\"${BASH} --login /root/setup/${script}\"" root ;
		}
	done
	cleanup_chroot
}

function setup_rootfs()
{
	build_ok setting up rootfs $1
	
	local rootfs interactive
	rootfs="${ROOTFS_REF[DIR]}"
	
	# copy files to rootfs/setup folder
	success sudo rm -rf ${rootfs}/root/setup
	# prepare rootfs environment
	source ${SRCDIR}/setup/setup.sh
	success sudo cp -a ${SRCDIR}/setup ${rootfs}/root
	
	interactive=""
	if [ ${ROOTFS_INTERACTIVE} = 1 ]; then
		interactive="interactive.sh"
	fi

	# execute the scripts
	success setupChroot ${ROOTFS_SCRIPTS} ${interactive}
	
	build_ok setting up rootfs $1
}

cd ${BUILDDIR}
success build_rootfs

cd ${BUILDDIR}
success copy_kernel_modules

cd ${BUILDDIR}
success setup_rootfs
