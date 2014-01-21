#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

build_ok invoked $0
eval "`load_configuration \"${ROOTFS_IMAGE[DIR]}\"`"

function build_rootfs()
{
	build_ok building rootfs

	local rootfs
	rootfs="$1"
	
	# we nee the -E flag to pass through http_proxy
	success "[ -r ${ROOTFS_FILE} ] || wget -O ${ROOTFS_IMAGE} ${ROOTFS_SOURCE};"
	cd ${rootfs}
	success sudo tar xzf ${ROOTFS_FILE}
	success sudo cp /usr/bin/qemu-arm-static ${rootfs}/usr/bin/
	
	build_ok built rootfs
}

function setup_rootfs()
{
	build_info setup_rootfs
	local rootfs
	rootfs="$1"
	
	success sudo mkdir -p ${rootfs}/root/setup
	success sudo cp -a ${SRCDIR}/setup/* ${rootfs}/root/setup
	for script in ${ROOTFS_SCRIPTS}; do
		execute sudo chroot ${rootfs} [ -r /root/setup/${script} ] && {
			success sudo chmod a+x ${rootfs}/root/setup/${script} ;
			success sudo chroot ${rootfs} /root/setup/${script} ;
		}
	done
	if [ ${ROOTFS_INTERACTIVE} = 1 ]; then
		success sudo chroot ${rootfs} "$SHELL -i"
	fi
}

#
# create extra filesystem used for compiling stuff like xbmc
#
#cd ${BUILDDIR}
#success prepare_image BUILDFS_IMAGE
#cd ${BUILDDIR}
#success build_rootfs ${BUILDFS_IMAGE[DIR]}

cd ${BUILDDIR}
success build_rootfs ${ROOTFS_DIR}

cd ${BUILDDIR}
success setup_rootfs ${ROOTFS_DIR}
