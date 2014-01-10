#!/bin/bash

[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

export BUILD_CLR_ESC=`echo -en "\033"`
export BUILD_CLR_GREEN="${BUILD_CLR_ESC}[0;32m"
export BUILD_CLR_YELLOW="${BUILD_CLR_ESC}[0;33m"
export BUILD_CLR_RED="${BUILD_CLR_ESC}[0;31m"
export BUILD_CLR_RST=`echo -en "${BUILD_CLR_ESC}[m\017"`
export BUILD_DEBUG=3

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
function build_err()
{
	if [ $BUILD_DEBUG -gt 0 ]; then 
		echo "${BUILD_CLR_RED}${@}${BUILD_CLR_RST}" 1>&2
		LSLOGSTACK 
		exit 1
	fi
}
function build_warn()
{
	if [ $BUILD_DEBUG -gt 1 ]; then 
		echo "${BUILD_CLR_YELLOW}${@}${BUILD_CLR_RST}" 1>&2
	fi
}
function build_ok()
{
	if [ $BUILD_DEBUG -gt 2 ]; then 
		echo "${BUILD_CLR_YELLOW}${@}${BUILD_CLR_RST}" 1>&2
	fi
}
function build_out()
{
	echo "${@}" 1>&2
}

function success()
{
	local CMD
	local RET
	CMD="$@"
	build_out "executing $CMD"
	eval $CMD
	RET=$?
	if [ $RET != 0 ]; then
		build_err "failed with code $RET"
	fi
}
