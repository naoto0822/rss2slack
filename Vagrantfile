# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos/7"

  config.vm.define :staging do |staging|
    staging.vm.hostname = "staging"
    staging.vm.network "private_network", ip: "192.168.56.30"
  end

  config.vm.define :dev do |dev|
    dev.vm.hostname = "dev"
    dev.vm.network "private_network", ip: "192.168.56.40"
  end
  
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end
  
  # config.vm.provision "ansible" do |ansible|
    # ansible.limit = "dev"
    # ansible.inventory_path = "./playbook/hosts"
    # ansible.playbook = "./playbook/dev_server.yml"
  # end
end
