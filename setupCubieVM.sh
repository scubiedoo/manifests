#!/bin/sh
set +i
PACKAGELIST=" \
	git \
	vim \
	build-essential \
	gcc-arm-linux-gnueabihf \
	qemu-kvm-extras-static \
	kpartx \
	u-boot-tools \
	ncurses-dev \
	units \
	bc \
	u-boot-tools \
	"

success()
{
	local CMD
	CMD="$@"
	local RET
	echo "executing $CMD" 1>&2
	eval $CMD
	RET=$?
	if [ $RET != 0 ]; then
		echo "failed with code $RET" 1>&2
		exit 1
	fi
}

success sudo apt-get update
success sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

success sudo apt-get install -y $PACKAGELIST
