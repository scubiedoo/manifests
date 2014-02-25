#!/bin/bash

[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

export BUILD_CLR_ESC=`echo -en "\033"`
export BUILD_CLR_GREEN="${BUILD_CLR_ESC}[0;32m"
export BUILD_CLR_YELLOW="${BUILD_CLR_ESC}[0;33m"
export BUILD_CLR_RED="${BUILD_CLR_ESC}[0;31m"
export BUILD_CLR_BLUE="${BUILD_CLR_ESC}[0;94m"
export BUILD_CLR_RST=`echo -en "${BUILD_CLR_ESC}[m\000"`

# build.sh needs to set BUILD_DEBUG
# therefore, while using the load_configuration mechanism i need an 
readonly DEFAULT_DEBUG=1
export DEFAULT_DEBUG

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
	if [ ${BUILD_DEBUG-$DEFAULT_DEBUG} -gt 0 ]; then 
		build_out "${BUILD_CLR_RED}${@}${BUILD_CLR_RST}"
		LSLOGSTACK 
		# better print the current setting for debugging
		[ ${BUILD_DEBUG-$DEFAULT_DEBUG} -gt 3 ] && { set; }
		
	fi
	exit 1
}
export -f build_err
function build_ok()
{
	if [ ${BUILD_DEBUG-$DEFAULT_DEBUG} -gt 1 ]; then 
		build_out "${BUILD_CLR_GREEN}${@}${BUILD_CLR_RST}"
	fi
}
export -f build_ok
function build_info()
{
	if [ ${BUILD_DEBUG-$DEFAULT_DEBUG} -gt 2 ]; then 
		build_out "${BUILD_CLR_YELLOW}${@}${BUILD_CLR_RST}"
	fi
}
export -f build_info
function build_debug()
{
	if [ ${BUILD_DEBUG-$DEFAULT_DEBUG} -gt 3 ]; then 
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
export -f execute

function success()
{
	local RET
	execute $@
	RET=$?
	if [ $RET != 0 ]; then
		build_err "failed with code $RET"
	fi
}
export -f success

function build_export()
{
	local var=$1
	local val="$2"
#	local c=`echo '[ -n "${'$1'+set}" ] && val="${'$1'}"'`
#	eval "$c"
	
	build_ok "exporting ${USERDEF} variable $var=$val"
	echo "export $var=\"$val\""
}
export -f build_export

function build_set()
{
	local var=$1
	local val="$2"
#	local c=`echo '[ -n "${'$1'+set}" ] && val="${'$1'}"'`
#	eval "$c"
	build_ok "setting ${USERDEF} variable $var=$val"
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
	
	export USERDEF="default"
	name="$dir/$prefix.default.sh"
	#[ -r $name ] || { echo "build_err config $name not found"; }
	success chmod a+x $name
	output="`$name $@`"
	build_debug "${output}"
	echo "${output}"
	
	export USERDEF="user-defined"
	name="$dir/$prefix.config.sh"
	execute [ -r $name ] && {
		success chmod a+x $name
		echo "`$name $@`"
	}
	unset USERDEF
}
export -f load_configuration

#
# trap handling
# i use this as a "try... finally" mechanism
#
# not so nice: uses a global variable.
# i'd prefer an "inline solution":
# saving all information in the trap call
# trap "trap_handle (...;cmd2;cmd1)" EXIT
#
# function trap_handle { parse $1; execute cmds[@] }
#
declare -a TRAP_CMDS
export TRAP_CMDS

function trap_push()
{
	local new_cmd store_ifs
	new_cmd="$1"
	
	build_info "PUSH: $new_cmd"
	
	store_ifs=${IFS}
	IFS='#'
	TRAP_CMDS=( "${new_cmd}" ${TRAP_CMDS[@]} )

	trap "trap_handler" EXIT
	IFS=${store_ifs}
}

function trap_pop()
{
	local store_ifs
	build_info "POP ${TRAP_CMDS[0]}"

	execute "${TRAP_CMDS[0]}"
	unset TRAP_CMDS[0]

	store_ifs=${IFS}
	IFS='#'
	TRAP_CMDS=( ${TRAP_CMDS[@]} )
	IFS=${store_ifs}
}

function trap_handler()
{
	local store_ifs
	build_ok "cleaning up"

	store_ifs=${IFS}
	IFS='#'
	for c in ${TRAP_CMDS[@]}; do
		execute "$c"
	done
	IFS=${store_ifs}
}
