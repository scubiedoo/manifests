Vagrant.configure("2") do |config|
  config.apt_proxy.http = "squid:80"
  config.apt_proxy.https = "squid:80"
  config.vm.box = "cubievm"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["modifyvm", :id, "--cpus", "4"]   
  end
  
  config.vm.provision :shell, path: "prepare/prepareEnvironment.sh"
  config.vm.provision :shell, path: "build.sh", :privileged => false
end
