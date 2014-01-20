#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

# config parameter
#
build_export BUILDDIR "/mnt/builddisk/vagrant"
build_export BUILD_DEBUG 3

#build_export http_proxy "squid:80"
#build_export https_proxy "squid:80"
#build_export ftp_proxy "squid:80"