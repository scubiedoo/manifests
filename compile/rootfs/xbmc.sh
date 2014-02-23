#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

build_ok running `basename ${BASH_ARGV[0]}`
eval "`load_configuration`"

XBMC_PREFIX="/opt/allwinner"
success sudo mkdir -p ${XBMC_PREFIX}
success sudo chown vagrant ${XBMC_PREFIX}
XBMC_SDKSTAGE="${ROOTFS_REF[DIR]}"

success sudo rm -f /lib/arm-linux-gnueabihf
success sudo rm -f /usr/lib/arm-linux-gnueabihf
success sudo rm -f /usr/include/arm-linux-gnueabihf
success sudo ln -sf ${XBMC_SDKSTAGE}/lib/arm-linux-gnueabihf /lib/arm-linux-gnueabihf
success sudo ln -sf ${XBMC_SDKSTAGE}/usr/lib/arm-linux-gnueabihf /usr/lib/arm-linux-gnueabihf
success sudo ln -sf ${XBMC_SDKSTAGE}/usr/include/arm-linux-gnueabihf /usr/include/arm-linux-gnueabihf

cd ${BUILDDIR}
success sync_git xbmca10 ${XBMC_GIT} ${XBMC_GIT_BRANCH}

execute grep A10HWR /etc/environment > /dev/null || {
	success sudo 'su -c "echo -e \"\\nA10HWR=1\" >> /etc/environment"'
}

success cd xbmca10
trap_push "cd `pwd`"
	success cd tools/a10/depends
	success sed -i "'s#^SDKSTAGE=.*\$#SDKSTAGE=${XBMC_SDKSTAGE}#g'" depends.mk
	success sed -i "'s#^XBMCPREFIX=.*\$#XBMCPREFIX=${XBMC_PREFIX}/xbmc-pvr-bin\$(HF)#g'" depends.mk
	success sed -i "'s#^TOOLCHAIN=.*\$#TOOLCHAIN=/usr/arm-linux-gnueabi\$(HF)#g'" depends.mk
	success sed -i "'s#^TARBALLS=.*\$#TARBALLS=${BUILDDIR}/tarballs#g'" depends.mk

	success make
	success make -C xbmc
trap_pop
success sudo make install

