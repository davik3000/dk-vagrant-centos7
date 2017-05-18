# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # #####
  # configuration variables
  # #####
  _config = "config"
  _vboxsf = "vboxsf"

  _provisionFolder_hostPath = "./"
  _provisionFolder_guestPath = "/tmp/vagrant/"

  _provisionFolder_config_hostPath = _provisionFolder_hostPath + _config
  _provisionFolder_config_guestPath = _provisionFolder_guestPath + _config
  _provisionFolder_scripts_guestPath = _provisionFolder_config_guestPath + "/scripts"

  _provisionScript_clean_hostPath = _provisionFolder_config_hostPath + "/clean.sh"
  _provisionScript_clean_args = _provisionFolder_config_guestPath

  _provisionScript_provision_hostPath = _provisionFolder_config_hostPath + "/provision.sh"
  _provisionScript_provision_args = _provisionFolder_scripts_guestPath

  _sharedFolder_hostPath = "./"
  _sharedFolder_guestPath = "/opt/vagrant/"
  _sharedFolder_config_hostPath = _sharedFolder_hostPath + _config
  _sharedFolder_config_guestPath = _sharedFolder_guestPath + _config
  _sharedFolder_vboxsf_hostPath = _sharedFolder_hostPath + _vboxsf
  _sharedFolder_vboxsf_guestPath = _sharedFolder_guestPath + _vboxsf

  # #####
  # vagrant vm definition
  # #####
  config.vm.box = "davik3000/CentOS-7"

  # vbguest: Should the plugin take the Guest Additions from remote or local installation? (default: remote)
  #config.vbguest.no_remote = true

  config.vm.define "main", primary: true do |main|
    main.vm.hostname = "main.example.com"
    main.vm.synced_folder ".", "/vagrant", disabled: true

    # check and exec only if plugin are not disabled
    if Vagrant.has_plugin?("vagrant-vbguest")
      # custom shared folder
      main.vm.synced_folder _sharedFolder_config_hostPath, _sharedFolder_config_guestPath, create: true
      main.vm.synced_folder _sharedFolder_vboxsf_hostPath, _sharedFolder_vboxsf_guestPath, create: true
    end

    main.vm.network "forwarded_port", host: 8001, guest: 8001
    main.vm.network "forwarded_port", host: 8002, guest: 8002
    main.vm.network "forwarded_port", host: 8003, guest: 8003
    main.vm.network "forwarded_port", host: 8004, guest: 8004
    main.vm.network "forwarded_port", host: 8005, guest: 8005
    main.vm.network "forwarded_port", host: 8080, guest: 8080

    main.vm.provider :virtualbox do |vb|
      vb.name = "vagrant-centos7-xfce"
      vb.cpus = 4
      vb.memory = "4096"

      # set the host as dns resolver
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

      vb.gui = true
    end

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
  end
end

