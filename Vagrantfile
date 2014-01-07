Vagrant.configure("2") do |config|
  config.vm.box = "precise32"
  config.vm.provider "virtualbox" do |v|
    v.name = "cubievm"
  end
#  config.apt_proxy.http  = "squid:80"
#  config.apt_proxy.https = "squid:80"
  
  config.vm.provision :shell, path: "setupCubieVM.sh"
end
