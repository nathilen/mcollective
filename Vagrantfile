# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"

  config.vm.define :mcclient do |config|
    config.vm.network :private_network, ip: "192.168.33.10"
    config.vm.hostname = "mc-client.vagrant"

    config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.module_path    = "modules"
      puppet.manifest_file  = "mcclient.pp"
    end
  end
  
  config.vm.define :node1 do |config|
    config.vm.network :private_network, ip: "192.168.33.11"
    config.vm.hostname = "node1.vagrant"

    config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.module_path    = "modules"
      puppet.manifest_file  = "node.pp"
    end
  end
end
