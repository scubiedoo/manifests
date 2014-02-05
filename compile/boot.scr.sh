#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

build_info running `basename $0`
eval "`load_configuration $@`"

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
	success sunxi-tools/fex2bin ${fexfile} script.bin
	build_ok built script.bin
}

cd ${BUILDDIR}
success sync_git "sunxi-tools" "${SCRIPT_TOOLS_GIT}" "${SCRIPT_TOOLS_GIT_BRANCH}"

cd ${BUILDDIR}
success sync_git "sunxi-boards" "${SCRIPT_BOARDS_GIT}" "${SCRIPT_BOARDS_GIT_BRANCH}"

cd ${BUILDDIR}
success build_fex2bin "sunxi-tools"

cd ${BUILDDIR}
success build_script ${SCRIPT_FEX_FILE}
