#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

source $SRCDIR/build/build.api.sh
eval "`load_configuration $@`"

source $SRCDIR/build/configuration.sh

source $SRCDIR/build/prepareEnvironment.sh
source $SRCDIR/compile/compile.sh
