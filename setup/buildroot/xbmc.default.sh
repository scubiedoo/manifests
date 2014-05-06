#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

build_set XBMC_GIT "http://github.com/scubiedoo/xbmc"
build_set XBMC_GIT_BRANCH "stage/Gotham"
