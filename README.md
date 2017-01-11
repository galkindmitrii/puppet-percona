puppet-percona
======

Puppet module for managing Percona XtraDB.

Included Vagrantfile will provision cluster of 3 Nodes on Centos7 boxes:

vagrant up galera1 && vagrant up

 - the 'master' node (galera1) will do the bootstraping, so 1 node in cluster shoud have:
 'master => true' for bootsrapping. Set master => false after bootstrap is done.
 - sample configs are located in examples/
 - 'xinetd' module should be also applied to all Galera nodes (for monitoring).
 - this module can also manage repositories for required RPMs. 

##Overview

This module is intended to be used to manage the Percona XtraDB Cluster.

This module was tested to work on Centos7/RHEL7 systems. Also with Puppet
Master and ENC (The Foreman).

##Module Description

The puppet module installs and configures Percona XtraDB for Mysql.

###Parameters

The following parameters are supported:

* **percona_version**: the Percona mysql version to be used.
* **root_password**: the root password of the database.
* **old_passwords**: set this to true to support the old mysql 3.x hashes for the passwords.
* **datadir**: the mysql data directory.
* **ist_recv_addr**: the IST receiver address for WSREP.
* **wsrep_max_ws_size**: the WSREP max working set size.
* **mysql_cluster_servers**: the string have to contains the ip or the fqan of the servers in the cluster parted by comma, like <ip1>,<ip2>,...
* **wsrep_cluster_address**: the WSREP cluster address list,It takes the value from the mysql_cluster_servers or you can set gcomm://<ip1>:4010,<ip2>:4010
* **wsrep_provider**: the WSREP provider.
* **wsrep_sst_receive_address**: the SST receiver address.
* **wsrep_sst_user**: the WSREP SST user, used to auth.
* **wsrep_sst_password**: the WSREP SST password, used to auth.
* **wsrep_sst_method**: the WSREP SST method, like rsync or xtrabackup.
* **wsrep_cluster_name**: the WSREP cluster name.
* **binlog_format**: the binlog format.
* **default_storage_engine**: the default storage engine.
* **innodb_autoinc_lock_mode**: the innodb lock mode.
* **innodb_locks_unsafe_for_binlog**: set this to true if you want to use unsafe locks for the binlogs.
* **innodb_buffer_pool_size**: the innodb buffer pool size.
* **innodb_log_file_size**: the innodb log file size.
* **innodb_file_per_table**: set this to true to allow using sepafate files for the innodb tablespace.
* **master**: set this to true to the first host in the cluster you are installing.

##Requirements

To use this module with the http cluster check install:
* [xinetd](https://forge.puppetlabs.com/puppetlabs/xinetd)

##Tested on

* CentOS 7.2
* Puppet 3.8.7 and also Foreman 1.12.

See tests/integration.rb for InSpec tests.

##Usage with Puppet Master & ENC (Foreman) or locally: 

**Example of YAML** 
```
  percona:
    master: true ## ONLY DURING CLUSTER BOOTSTRAP
    mysql_cluster_servers: 10.10.10.1,10.10.10.2,10.10.10.3
    percona_version: '56'
    pkg_version: '5.6'
    root_password: $SOMEPASSWORD
    wsrep_cluster_name: $SOMECLUSTERNAME
    wsrep_sst_method: xtrabackup-v2
    wsrep_sst_password: $SOMEPASSWORD
```

* Install the module on the Puppet master (+optionally xinetd module)
* Import the module to Foreman

For local usage with puppet apply see Vagrantfile.

##IMPORTANT:

Don't forget that state transfer within Cluster is not encrypted by default!
Donor node is recommended to be used for Backups and not the "Live" connections.
