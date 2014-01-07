Vagrant.configure("2") do |config|
  config.vm.box = "precise32"
  config.vm.provider "virtualbox" do |v|
    v.name = "cubievm"
  end
  config.vm.provision :shell, path: "/vagrant/setupCubieVM.sh"
end
