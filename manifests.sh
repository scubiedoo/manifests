#!/bin/bash

readonly VAGRANT_PROVISION=1
export VAGRANT_PROVISION

readonly STARTDIR=`pwd`
export STARTDIR

export SRCDIR="`dirname $0`"
if [ ! -r $SRCDIR/build/build.sh ]; then
	SRCDIR="/vagrant"
fi

if [ -r $SRCDIR/build/build.sh ]; then
	readonly SRCDIR
	cd $SRCDIR
	# use complete path for stack trace
	source $SRCDIR/build/build.sh
else
	echo "There is something wrong..."
	echo -e "\tSTARTDIR=$STARTDIR"
	echo -e "\tSRCDIR=$SRCDIR"
	echo -e "\tSCRIPTDIR=`dirname $0`"
	echo "but I can't find $SRCDIR/build/build.sh"
	exit 1
fi
