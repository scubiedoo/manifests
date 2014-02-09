Vagrant.configure("2") do |config|
  config.apt_proxy.http = ENV['HTTP_PROXY']
  config.apt_proxy.https = ENV['HTTPS_PROXY']
  config.vm.box = "cubievm"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["modifyvm", :id, "--cpus", "4"]   
  end
  
  config.vm.provision :shell, :privileged => false, :inline => <<-SH
  export http_proxy=ENV['HTTP_PROXY']
  export https_proxy=ENV['HTTPS_PROXY']
  export ftp_proxy=ENV['FTP_PROXY']
  /vagrant/manifests.sh
SH
end
