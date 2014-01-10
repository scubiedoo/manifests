#!/bin/sh

run_ok()
{
	local CMD
	local RET
	CMD="$@"
	echo "executing $CMD" 1>&2
	eval $CMD
	RET=$?
	if [ $RET != 0 ]; then
		echo "failed with code $RET" 1>&2
		exit 1
	fi
}

run_ok mkdir -p vm
run_ok [ -r vm/precise32.box ] || (cd vm; wget http://files.vagrantup.com/precise32.box; cd -)

run_ok vagrant box add precise32 precise32.box

run_ok vagrant plugin install vagrant-proxyconf

run_ok vagrant up

#run_ok vagrant package --base cubievm --output cubievm.box --vagrantfile Vagrantfile.cubievm
run_ok vagrant box add --force cubievm precise32.box
run_ok vagrant box repackage cubievm virtualbox
run_ok mv package.box vm/cubievm.box
