#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

build_set SCRIPT_TOOLS_GIT "https://github.com/linux-sunxi/sunxi-tools"
build_set SCRIPT_TOOLS_GIT_BRANCH "master"

build_set SCRIPT_BOARDS_GIT "https://github.com/linux-sunxi/sunxi-boards"
build_set SCRIPT_BOARDS_GIT_BRANCH "master"

build_set SCRIPT_FEX_FILE "sunxi-boards/sys_config/a20/cubieboard2.fex"
