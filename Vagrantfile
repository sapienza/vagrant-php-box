# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  forward_port = ->(guest, host = guest) do
    config.vm.network :forwarded_port,
      guest: guest,
      host: host,
      auto_correct: true
  end
  
  # Sync between the web root of the VM and the 'sites' directory
  config.vm.synced_folder "sites/", "/var/www"

  forward_port[1080]      # mailcatcher
  forward_port[3306]      # mysql
  forward_port[80, 8080]  # nginx/apache

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "default.pp"
  end

  config.vm.network :private_network, ip: "33.33.33.10"
end
