#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

source build/build.api.sh
eval "`load_configuration $@`"

source build/prepareEnvironment.sh
source compile/compile.sh

#apt-get install bc units kpartx 