Vagrant.configure("2") do |config|
  config.apt_proxy.http = ENV['HTTP_PROXY']
  config.apt_proxy.https = ENV['HTTPS_PROXY']
  config.vm.box = "cubievm"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["modifyvm", :id, "--cpus", "4"]   
  end
  
  config.vm.provision :shell, path: "manifests.sh", :privileged => false
end
