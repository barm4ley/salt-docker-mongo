# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #config.vm.provider :virtualbox do |vb|
    #vb.gui = true
  #end

  config.vm.define :master do |master_config|
    master_config.vm.box = "debian/jessie64"
    master_config.vm.host_name = 'saltmaster'
    master_config.vm.network "private_network", ip: "192.168.50.10"
    master_config.vm.synced_folder "saltstack/salt/", "/srv/salt"
    master_config.vm.synced_folder "saltstack/pillar/", "/srv/pillar"

    master_config.vm.provision :salt do |salt|
      salt.master_config = "saltstack/etc/master"
      salt.master_key = "saltstack/keys/master_minion.pem"
      salt.master_pub = "saltstack/keys/master_minion.pub"
      salt.minion_key = "saltstack/keys/master_minion.pem"
      salt.minion_pub = "saltstack/keys/master_minion.pub"
      salt.seed_master = {
                          "consul" => "saltstack/keys/minion1.pub",
                          "mongo1" => "saltstack/keys/minion2.pub",
                          "mongo2" => "saltstack/keys/minion3.pub",
                          "mongo3" => "saltstack/keys/minion4.pub",
                          "cran"   => "saltstack/keys/minion5.pub"
                         }

      salt.install_type = "stable"
      salt.install_master = true
      salt.no_minion = true
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end
  end

  config.vm.define :consul do |minion_config|
    minion_config.vm.box = "debian/jessie64"
    minion_config.vm.host_name = 'consul'
    minion_config.vm.network "private_network", ip: "192.168.50.12"

    minion_config.vm.provision :salt do |salt|
      salt.minion_config = "saltstack/etc/minion1"
      salt.minion_key = "saltstack/keys/minion1.pem"
      salt.minion_pub = "saltstack/keys/minion1.pub"
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end
  end

  config.vm.define :mongo1 do |minion_config|
    minion_config.vm.box = "debian/jessie64"
    minion_config.vm.host_name = 'mongo1'
    minion_config.vm.network "private_network", ip: "192.168.50.21"

    minion_config.vm.provision :salt do |salt|
      salt.minion_config = "saltstack/etc/minion2"
      salt.minion_key = "saltstack/keys/minion2.pem"
      salt.minion_pub = "saltstack/keys/minion2.pub"
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end
  end

  config.vm.define :mongo2 do |minion_config|
    minion_config.vm.box = "debian/jessie64"
    minion_config.vm.host_name = 'mongo2'
    minion_config.vm.network "private_network", ip: "192.168.50.22"

    minion_config.vm.provision :salt do |salt|
      salt.minion_config = "saltstack/etc/minion3"
      salt.minion_key = "saltstack/keys/minion3.pem"
      salt.minion_pub = "saltstack/keys/minion3.pub"
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end
  end

  config.vm.define :mongo3 do |minion_config|
    minion_config.vm.box = "debian/jessie64"
    minion_config.vm.host_name = 'mongo3'
    minion_config.vm.network "private_network", ip: "192.168.50.23"

    minion_config.vm.provision :salt do |salt|
      salt.minion_config = "saltstack/etc/minion4"
      salt.minion_key = "saltstack/keys/minion4.pem"
      salt.minion_pub = "saltstack/keys/minion4.pub"
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end
  end

  config.vm.define :cran do |minion_config|
    minion_config.vm.box = "debian/jessie64"
    minion_config.vm.host_name = 'cran'
    minion_config.vm.network "private_network", ip: "192.168.50.31"

    minion_config.vm.provision :salt do |salt|
      salt.minion_config = "saltstack/etc/minion5"
      salt.minion_key = "saltstack/keys/minion5.pem"
      salt.minion_pub = "saltstack/keys/minion5.pub"
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end
  end

end
