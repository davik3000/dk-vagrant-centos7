# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #_provision_config_src_path="./config"

  _provision_script_path="./config/provision.sh"

  config.vm.box = "davik3000/CentOS-7"

  #config.vbguest.no_remote = true
  
  config.vm.define "main", primary: true do |main|
    main.vm.hostname = "main.example.com"
    main.vm.synced_folder ".", "/vagrant", disabled: true
    
    main.vm.provider :virtualbox do |vb|
      vb.memory = "4096"
      vb.name = "vagrant-centos7-xfce"
      vb.cpus = 2

      vb.gui = true
    end

    main.vm.provision :shell, path: _provision_script_path

  end
end
