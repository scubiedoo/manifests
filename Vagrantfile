Vagrant.configure("2") do |config|
  config.proxy.http = ENV['HTTP_PROXY']
  config.proxy.https = ENV['HTTPS_PROXY']
  config.apt_proxy.http = ENV['HTTP_PROXY']
  config.apt_proxy.https = ENV['HTTPS_PROXY']
  
# we have to wait for the new plugin version... :/
#  config.git_proxy.http = ENV['HTTP_PROXY']
#  config.git_proxy.https = ENV['HTTPS_PROXY']
#  config.svn_proxy.http = ENV['HTTP_PROXY']
#  config.svn_proxy.https = ENV['HTTPS_PROXY']
  
  config.vm.box = "cubievm"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["modifyvm", :id, "--cpus", "4"]   
  end
  
  config.vm.provision :shell, :privileged => false, path: "manifests.sh"
end
