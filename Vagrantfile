# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # #####
  # configuration variables
  # #####
  _provisionFolder_config_hostPath = "./config"
  _provisionFolder_config_guestPath = "/tmp/vagrant/config"
  _provisionFolder_scripts_guestPath = _provisionFolder_config_guestPath + "/scripts"

  _provisionScript_clean_hostPath = "./config/clean.sh"
  _provisionScript_clean_args = _provisionFolder_config_guestPath

  _provisionScript_provision_hostPath = "./config/provision.sh"
  _provisionScript_provision_args = _provisionFolder_scripts_guestPath

  # #####
  # vagrant vm definition
<<<<<<< HEAD
  # #####
=======
  # #####
>>>>>>> d3ce079... Fixed previous commit
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
<<<<<<< HEAD

=======

>>>>>>> d3ce079... Fixed previous commit
    # #####
    # provisioning
    # #####
    # DART clean from previous provision
    main.vm.provision :shell do |s|
      s.path = _provisionScript_clean_hostPath
      s.args = [_provisionScript_clean_args]
    end
    # DART send config
    main.vm.provision :file do |f|
      f.source = _provisionFolder_config_hostPath
      f.destination = _provisionFolder_config_guestPath
    end
    # DART apply config
    main.vm.provision :shell do |s|
      s.path = _provisionScript_provision_hostPath
      s.args = [_provisionScript_provision_args]
    end
<<<<<<< HEAD

=======
>>>>>>> d3ce079... Fixed previous commit
  end
end
