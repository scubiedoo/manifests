#!/bin/bash

readonly VAGRANT_PROVISION=1
export VAGRANT_PROVISION

readonly STARTDIR=`pwd`
export STARTDIR
readonly SRCDIR="/vagrant"
export SRCDIR

cd $SRCDIR
source build/build.sh

#apt-get install bc units kpartx 