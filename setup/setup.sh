#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

#
# setup configuration will be applied to the chroot environment
# respectively, root bashrc

# read setup configuration and don't evaluate it yet, but copy to the rootfs as source file
cat > $SRCDIR/setup/.bashrc.chroot << EOF
#
# this file has been automatically created from setup/setup.sh
#
export VAGRANT_PROVISION=1
export BUILD_DEBUG=${BUILD_DEBUG}
source $SRCDIR/build/build.api.sh
export BUILD_CLR_GREEN="\${BUILD_CLR_ESC}[0;92m"
export BUILD_CLR_YELLOW="\${BUILD_CLR_ESC}[0;36m"
export BUILD_CLR_RED="\${BUILD_CLR_ESC}[0;35m"

EOF
load_configuration >> $SRCDIR/setup/.bashrc.chroot

# really load the setup/.bashrc.chroot
# but only add the line if it doesn't exist yet
execute sudo grep -Fq ".bashrc.chroot" ${ROOTFS_REF[DIR]}/root/.bash_profile || {
	success sudo su -c "\"echo \\\"[ -r /root/setup/.bashrc.chroot ] && { source /root/setup/.bashrc.chroot; }\\\" >> ${ROOTFS_REF[DIR]}/root/.bash_profile\""
}
