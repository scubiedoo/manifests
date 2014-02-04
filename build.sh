#!/bin/bash

# prepare
# i like to start from my source dir so that i have control over my directory structure and include paths
#
# this is a dirty trick ^^ sorry in advance.
# vagrant copies the build.sh script to /tmp/vagrant-shell for executing.
# i cannot use the load_configuration mechanism provided by build.api.sh
# because it would search for vagrant-shell instead of build.sh
# thus i restart the command from its real path.
# now load_configuration can finds the files ;)
ls `dirname $0`/build.api.sh &> /dev/null || { echo "restarting command: $@" ; exec /vagrant/build.sh $@; exit $?; }

# START
#
readonly VAGRANT_PROVISION=1
export VAGRANT_PROVISION

readonly STARTDIR=`pwd`
export STARTDIR
readonly SRCDIR="/vagrant"
export SRCDIR

cd $SRCDIR
source "$SRCDIR/build.api.sh"

eval `load_configuration`

source prepare/prepareEnvironment.sh
source build/compile.sh $@


#apt-get install bc units kpartx 