#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

# config parameter
#
build_export MENUCONFIG_SVN "http://menuconfig.googlecode.com/svn/trunk/"
