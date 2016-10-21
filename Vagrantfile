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
    master_config.vm.synced_folder "saltstack/master.d/", "/etc/salt/master.d"

    master_config.vm.provision :salt do |salt|
      salt.master_config = "saltstack/etc/master"
      salt.master_key = "saltstack/keys/master_minion.pem"
      salt.master_pub = "saltstack/keys/master_minion.pub"
      salt.minion_key = "saltstack/keys/master_minion.pem"
      salt.minion_pub = "saltstack/keys/master_minion.pub"
      salt.seed_master = {
                          "consul" => "saltstack/keys/consul.pub",
                          "mongo1" => "saltstack/keys/mongo1.pub",
                          "mongo2" => "saltstack/keys/mongo2.pub",
                          "mongo3" => "saltstack/keys/mongo3.pub",
                          "cran1"  => "saltstack/keys/cran1.pub",
                          "cran2"  => "saltstack/keys/cran2.pub",
                          "cran3"  => "saltstack/keys/cran3.pub"
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
      salt.minion_config = "saltstack/etc/consul"
      salt.minion_key = "saltstack/keys/consul.pem"
      salt.minion_pub = "saltstack/keys/consul.pub"
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
      salt.minion_config = "saltstack/etc/mongo1"
      salt.minion_key = "saltstack/keys/mongo1.pem"
      salt.minion_pub = "saltstack/keys/mongo1.pub"
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
      salt.minion_config = "saltstack/etc/mongo2"
      salt.minion_key = "saltstack/keys/mongo2.pem"
      salt.minion_pub = "saltstack/keys/mongo2.pub"
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
      salt.minion_config = "saltstack/etc/mongo3"
      salt.minion_key = "saltstack/keys/mongo3.pem"
      salt.minion_pub = "saltstack/keys/mongo3.pub"
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end
  end

  config.vm.define :cran1 do |minion_config|
    minion_config.vm.box = "debian/jessie64"
    minion_config.vm.host_name = 'cran1'
    minion_config.vm.network "private_network", ip: "192.168.50.31"

    minion_config.vm.provision :salt do |salt|
      salt.minion_config = "saltstack/etc/cran1"
      salt.minion_key = "saltstack/keys/cran1.pem"
      salt.minion_pub = "saltstack/keys/cran1.pub"
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end
  end

  config.vm.define :cran2 do |minion_config|
    minion_config.vm.box = "debian/jessie64"
    minion_config.vm.host_name = 'cran2'
    minion_config.vm.network "private_network", ip: "192.168.50.32"

    minion_config.vm.provision :salt do |salt|
      salt.minion_config = "saltstack/etc/cran2"
      salt.minion_key = "saltstack/keys/cran2.pem"
      salt.minion_pub = "saltstack/keys/cran2.pub"
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end
  end

  config.vm.define :cran3 do |minion_config|
    minion_config.vm.box = "debian/jessie64"
    minion_config.vm.host_name = 'cran3'
    minion_config.vm.network "private_network", ip: "192.168.50.33"

    minion_config.vm.provision :salt do |salt|
      salt.minion_config = "saltstack/etc/cran3"
      salt.minion_key = "saltstack/keys/cran3.pem"
      salt.minion_pub = "saltstack/keys/cran3.pub"
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end
  end

end
