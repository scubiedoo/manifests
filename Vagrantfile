Vagrant.configure("2") do |config|
  config.vm.box = "precise32"
  config.vm.provider "virtualbox" do |v|
    v.name = "cubievm"
  end
  config.apt_proxy.http  = ENV['HTTP_PROXY']
  config.apt_proxy.https = ENV['HTTPS_PROXY']
  
  config.vm.provision :shell, path: "setupCubieVM.sh"
end
