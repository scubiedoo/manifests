#!/bin/sh

success()
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

success mkdir -p vm
success [ -r vm/precise32.box ] || (cd vm; wget http://files.vagrantup.com/precise32.box; cd -)

success vagrant box add precise32 precise32.box

success vagrant plugin install vagrant-proxyconf

success vagrant destroy
success vagrant up

success vagrant package --base cubievm --output vm/cubievm.box --vagrantfile Vagrantfile.cubievm
success vagrant box add --force cubievm vm/cubievm.box
