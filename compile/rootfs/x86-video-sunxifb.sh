#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

build_info running `basename ${BASH_ARGV[0]}`
eval "`load_configuration $@`"

# https://github.com/ssvb/xf86-video-sunxifb

cd ${BUILDDIR}

