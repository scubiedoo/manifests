#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

build_set SUNXIFB_GIT "https://github.com/ssvb/xf86-video-fbturbo"
build_set SUNXIFB_GIT_BRANCH "master"
