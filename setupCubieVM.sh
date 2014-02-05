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
	"

run_ok()
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

run_ok sudo apt-get update
run_ok sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

run_ok sudo apt-get install -y $PACKAGELIST
