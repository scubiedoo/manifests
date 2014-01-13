cubie_dev_disk="vm/cubiedev.vdi"
Vagrant.configure("2") do |config|
  config.apt_proxy.http = "squid:80"
  config.apt_proxy.https = "squid:80"
  config.vm.box = "cubievm"

  config.vm.provision :shell, path: "prepare/prepareEnvironment.sh"
  config.vm.provision :shell, path: "build.sh"
end
