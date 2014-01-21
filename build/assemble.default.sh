#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from build.sh" 1>&2; exit 1; }

build_set IMAGE "/vagrant/generated.img"
build_set IMAGE_SIZE "2G"
