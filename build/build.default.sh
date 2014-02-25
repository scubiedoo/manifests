#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

# config parameter
#
build_export BUILD_DEBUG 3

# actually only used for menuconfig...
build_export BUILDDIR "/tmp"
