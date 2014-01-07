
mkdir cubievm
cd cubievm
cmd /c vagrant up
cmd /c vagrant package --base cubievm --output cubievm.box --vagrantfile Vagrantfile.cubievm
cmd /c vagrant box add --force cubievm cubievm.box
cd ..
