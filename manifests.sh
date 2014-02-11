#!/bin/bash

readonly VAGRANT_PROVISION=1
export VAGRANT_PROVISION

readonly STARTDIR=`pwd`
export STARTDIR
readonly SRCDIR="/vagrant"
export SRCDIR

cd $SRCDIR
# use complete path for stack trace
source $SRCDIR/build/build.sh

#apt-get install bc units kpartx 