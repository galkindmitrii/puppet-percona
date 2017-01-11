# -*- mode: ruby -*-
# vi: set ft=ruby :

box = 'centos/7'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"


#
# First box -> galera1 is a Master node
#
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # we don't need to recreate the key every time:
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", type: "rsync"
  config.vm.define "galera1" do |galera1|
    galera1.vm.box = box
    galera1.vm.network "private_network", ip: "192.168.99.101"
    galera1.vm.provider :libvirt do |v|
      v.memory = 4096
      v.cpus = 2
    end

    galera1.vm.hostname = 'galera1'

    galera1.vm.provision :shell do |shell|
      shell.inline = "rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm;" +
                     "yum clean all;" +
                     "yum -y install puppet firewalld;" +
		     "puppet module install puppetlabs-stdlib;" +
		     "puppet module install puppetlabs-xinetd;"  ## we need official rhel7 version (3.8.7 atm)
    end

    # Workaround for Vagrant ver 1.9.1 for: https://github.com/mitchellh/vagrant/issues/8096
    galera1.vm.provision :shell do |shell|
      shell.inline = 'service network restart'
    end

    galera1.vm.provision :shell do |shell|
      shell.inline = 'mkdir /etc/puppet/modules/percona ;' +
                     'cp -r /vagrant/* /etc/puppet/modules/percona/ ;' +
                     'systemctl start firewalld.service;'
    end

    galera1.vm.provision :shell do |shell|
      shell.inline = 'puppet apply --verbose --modulepath=/etc/puppet/modules --debug /etc/puppet/modules/percona/examples/centos7.pp'
    end

  end


#
# Second box, same config except master == false, (galera2)
#
  config.vm.define "galera2" do |galera2|
    galera2.vm.box = box
    galera2.vm.network "private_network", ip: "192.168.99.102"
    galera2.vm.provider :libvirt do |v|
      v.memory = 4096
      v.cpus = 2
    end

    galera2.vm.hostname = 'galera2'

    galera2.vm.provision :shell do |shell|
    shell.inline = "rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm;" +
                   "yum clean all;" +
                   "yum -y install puppet firewalld;" +
                   "puppet module install puppetlabs-stdlib;" +
                   "puppet module install puppetlabs-xinetd;"  ## we need official rhel7 version (3.8.7 atm)
    end

    # Workaround for Vagrant ver 1.9.1 for: https://github.com/mitchellh/vagrant/issues/8096
    galera2.vm.provision :shell do |shell|
      shell.inline = 'service network restart'
    end

    galera2.vm.provision :shell do |shell|
      shell.inline = 'mkdir /etc/puppet/modules/percona ;' +
                     'cp -r /vagrant/* /etc/puppet/modules/percona/ ;' +
		     'systemctl start firewalld.service ;'
    end

    galera2.vm.provision :shell do |shell|
      shell.inline = 'puppet apply --verbose --modulepath=/etc/puppet/modules --debug /etc/puppet/modules/percona/examples/site.pp'
    end

  end

#
# Third box, same config as for second one, (galera3)
#
  config.vm.define "galera3" do |galera3|
    galera3.vm.box = box
    galera3.vm.network "private_network", ip: "192.168.99.103"
    galera3.vm.provider :libvirt do |v|
      v.memory = 4096
      v.cpus = 2
    end

    galera3.vm.hostname = 'galera3'

    galera3.vm.provision :shell do |shell|
    shell.inline = "rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm;" +
                   "yum clean all;" +
                   "yum -y install puppet firewalld;" +
                   "puppet module install puppetlabs-stdlib;" +
                   "puppet module install puppetlabs-xinetd;"  ## we need official rhel7 version (3.8.7 atm)
    end

    # Workaround for Vagrant ver 1.9.1 for: https://github.com/mitchellh/vagrant/issues/8096
    galera3.vm.provision :shell do |shell|
      shell.inline = 'service network restart'
    end

    galera3.vm.provision :shell do |shell|
      shell.inline = 'mkdir /etc/puppet/modules/percona ;' +
                     'cp -r /vagrant/* /etc/puppet/modules/percona/ ;' +
		     'systemctl start firewalld.service ;'
    end

    galera3.vm.provision :shell do |shell|
      shell.inline = 'puppet apply --verbose --modulepath=/etc/puppet/modules --debug /etc/puppet/modules/percona/examples/site.pp'
    end

  end

end
