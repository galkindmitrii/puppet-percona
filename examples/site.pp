#
# Example for setting up a NON-bootstrap node. This one will join an
# already bootstrapped Cluster.
# (bootsrap done by node with master => true setting).
#

# Innodb buffer == 50% of total ram:
$buffer_pool_size = 0.50 * $::memorysize_mb
$buffer_pool_size_mb = inline_template("<%= @buffer_pool_size.to_i %>")

notify {"Determined InnoDB buffer pool size as \$buffer_pool_size_mb ${$buffer_pool_size_mb} MB":}

# the last one on the list will be set as donor:
$galera_nodes = ['192.168.99.101', '192.168.99.102', '192.168.99.103']


node default {
  include ::stdlib

  class { 'xinetd':
  }

  class { 'percona':
    manage_repo             => true,
    master                  => false,
    mysql_cluster_servers   => join($galera_nodes,","),
    root_password           => 'AVERYLONGPASSWORD',
    wsrep_sst_method        => 'xtrabackup-v2',
    wsrep_cluster_name      => 'PERCONA_CLUSTER',
    wsrep_sst_donor         => $galera_nodes[-1],
    innodb_buffer_pool_size => "${buffer_pool_size_mb}M",
  }
}
