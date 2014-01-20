#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

echo "load_configuration $@"
build_ok invoked 
eval "`load_configuration $@`"

function build_rootfs()
{
	build_ok building rootfs

	local rootfs
	rootfs="$1"
	
	# we nee the -E flag to pass through http_proxy
	success "[ -r ${ROOTFS_IMAGE} ] || { wget -O ${ROOTFS_IMAGE} ${ROOTFS_SOURCE}; }"
	cd ${rootfs}
	success sudo tar xzf ${ROOTFS_IMAGE}
	success sudo cp /usr/bin/qemu-arm-static ${rootfs}/usr/bin/
	
	build_ok built rootfs
}

function setup_rootfs()
{
	build_info setup_rootfs
	local rootfs
	rootfs="$1"
	
	success sudo chroot ${rootfs} "echo -e "root\nroot" |passwd root"
	if [ ${ROOTFS_INTERACTIVE} = 1 ]; then
		success sudo chroot ${rootfs} "$SHELL -i"
	fi
}

cd ${BUILDDIR}
success build_rootfs ${ROOTFS_DIR}

cd ${BUILDDIR}
success setup_rootfs ${ROOTFS_DIR}
