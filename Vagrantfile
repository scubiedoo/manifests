cubie_dev_disk="cubiedev.vdi"
Vagrant.configure("2") do |config|
  config.apt_proxy.http = "squid:80"
  config.apt_proxy.https = "squid:80"
  config.vm.box = "cubievm"
  config.vm.provider "virtualbox" do | vb |
    unless File.exist?(cubie_dev_disk)
      vb.customize ['createhd', '--filename', cubie_dev_disk, '--size', 5000 * 1024]
    end
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', cubie_dev_disk]  
  end
end