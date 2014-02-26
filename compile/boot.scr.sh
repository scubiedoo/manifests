#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

build_info running `basename $0`

function build_fex2bin()
{
	build_ok building fex2bin
	success cd sunxi-tools
	success "make fex2bin"
	build_ok built fex2bin
}

function build_script()
{
	local fexfile
	build_ok building script.bin
	fexfile="$1"
	success sudo sunxi-tools/fex2bin ${fexfile} ${BOOTFS_REF[DIR]}/script.bin
	
	build_ok built script.bin
}

# currently, we don't need boot.scr 
# 
function build_bootscr()
{
	build_ok building boot.scr
	local boot_cmd="/tmp/boot.cmd"
	success rm -f ${boot_cmd}
	
	echo "setenv bootargs console=ttyS0,115200 root=/dev/mmcblk0p2 rootwait panic=10 `echo -e -n ${CONFIG_BOOT_CMD_EXTRA}`" > ${boot_cmd}
	execute [ $? = 0 ] || build_err "echoing to $boot_cmd failed"
	
	cat >> ${boot_cmd} << EOF
fatload mmc 0 0x43000000 script.bin || ext2load mmc 0 0x43000000 boot/script.bin
fatload mmc 0 0x48000000 uImage || ext2load mmc 0 0x48000000 uImage boot/uImage
bootm 0x48000000
EOF
	execute [ $? = 0 ] || build_err "creating $boot_cmd failed"
	
	success sudo rm -f ${BOOTFS_REF[DIR]}/boot.scr
	success sudo mkimage -C none -A arm -T script -d ${boot_cmd} ${BOOTFS_REF[DIR]}/boot.scr
	
	build_ok built boot.scr
}

if [ ${CONFIG_BUILD_BOOT_SCR} = "y" ]; then

	cd ${BUILDDIR}
	success sync_git "sunxi-tools" "${CONFIG_SCRIPT_TOOLS_GIT}" "${CONFIG_SCRIPT_TOOLS_GIT_BRANCH}"

	cd ${BUILDDIR}
	success sync_git "sunxi-boards" "${CONFIG_SCRIPT_BOARDS_GIT}" "${CONFIG_SCRIPT_BOARDS_GIT_BRANCH}"

	cd ${BUILDDIR}
	success build_fex2bin "sunxi-tools"

	cd ${BUILDDIR}
	success build_script ${CONFIG_SCRIPT_FEX_FILE}

	cd ${BUILDDIR}
	success build_bootscr
fi
