#!/bin/bash

[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

export BUILD_CLR_ESC=`echo -en "\033"`
export BUILD_CLR_GREEN="${BUILD_CLR_ESC}[0;32m"
export BUILD_CLR_YELLOW="${BUILD_CLR_ESC}[0;33m"
export BUILD_CLR_RED="${BUILD_CLR_ESC}[0;31m"
export BUILD_CLR_BLUE="${BUILD_CLR_ESC}[0;34m"
export BUILD_CLR_RST=`echo -en "${BUILD_CLR_ESC}[m\000"`
export BUILD_DEBUG=4

# COPY START http://blog.yjl.im/2012/01/printing-out-call-stack-in-bash.html
# 
# Copyright 2012 Yu-Jie Lin
# MIT License
# Log Call Stack
LSLOGSTACK () {
  local i=0
  local FRAMES=${#BASH_LINENO[@]}
  # FRAMES-2 skips main, the last one in arrays
  for ((i=FRAMES-2; i>=0; i--)); do
    echo '  File' \"${BASH_SOURCE[i+1]}\", line ${BASH_LINENO[i]}, in ${FUNCNAME[i+1]}
    # Grab the source code of the line
    sed -n "${BASH_LINENO[i]}{s/^/    /;p}" "${BASH_SOURCE[i+1]}"
  done
}
# COPY END

function build_out()
{
	echo "${@}" 1>&2
}
export -f build_out
function build_err()
{
	if [ $BUILD_DEBUG -gt 0 ]; then 
		build_out "${BUILD_CLR_RED}${@}${BUILD_CLR_RST}"
		LSLOGSTACK 
		exit 1
	fi
}
export -f build_err
function build_info()
{
	if [ $BUILD_DEBUG -gt 1 ]; then 
		build_out "${BUILD_CLR_YELLOW}${@}${BUILD_CLR_RST}"
	fi
}
export -f build_info
function build_ok()
{
	if [ $BUILD_DEBUG -gt 2 ]; then 
		build_out "${BUILD_CLR_GREEN}${@}${BUILD_CLR_RST}"
	fi
}
export -f build_ok

function build_debug()
{
	if [ $BUILD_DEBUG -gt 3 ]; then 
		build_out "${BUILD_CLR_BLUE}${@}${BUILD_CLR_RST}"
	fi
}
export -f build_debug

function execute()
{
	local CMD
	CMD="$@"
	build_info "executing $CMD"
	eval $CMD
}

function success()
{
	local RET
	execute $@
	RET=$?
	if [ $RET != 0 ]; then
		build_err "failed with code $RET"
	fi
}

function build_export()
{
	local var=$1
	local val="$2"
	build_ok "exporting user-defined variable $var=$val"
	echo "export $var=\"$val\""
}
export -f build_export

function build_set()
{
	local var=$1
	local val="$2"
	build_ok "setting user-defined variable $var=$val"
	echo "$var=\"$val\""
}
export -f build_set

function load_configuration()
{
build_debug "`set`"
	local name dir prefix output
	name=`basename ${BASH_SOURCE[1]}`
	dir=`dirname ${BASH_SOURCE[1]}`
	prefix=${name%.sh}
	
	name="$dir/$prefix.default.sh"
	success chmod a+x $name
	output="`$name $@`"
	build_debug "${output}"
	echo "${output}"
	
	name="$dir/$prefix.config.sh"
	execute [ -r $name ] && {
		success chmod a+x $name
		echo "`$name $@`"
	}
}
export -f load_configuration