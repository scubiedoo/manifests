#!/bin/bash
export VAGRANT_PROVISION=1

# prepare
# i like to start from my source dir so that i have control over my directory structure and include paths
#
STARTDIR=`pwd`
SRCDIR="/vagrant"
cd $SRCDIR
source "$SRCDIR/build.api.sh"

# read configuration file
#
CONFIGFILE="build.config.sh"
success chmod a+x $CONFIGFILE
eval `./$CONFIGFILE`

