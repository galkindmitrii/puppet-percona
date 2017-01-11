# encoding: utf-8

mysql_cmd = "mysql -u root --password='AVERYLONGPASSWORD' -e "

control 'base-galera-cluster-creation' do
  impact 1.0
  title 'Basic Galera Cluster Integration Tests'
  desc 'Various simple integration tests.'

    # Percona Galera 3 rpm should be installed:
    describe package('Percona-XtraDB-Cluster-galera-3') do
      it { should be_installed }
    end

    # Ensure that mysql is running (Master should have bootstrap service / All others just mysql):
    describe command("systemctl list-units | grep mysql.*.service") do
      its('exit_status') { should eq 0 }
      its('stdout') { should match /loaded active running/}
    end

    # Ensure that Xinet is running:
    describe service("xinetd") do
      it { should be_running }
    end

    # Ensure a correct WSRP status:
    describe command(mysql_cmd + "\"SHOW GLOBAL STATUS LIKE \'wsrep_connected\';\"") do
      its('exit_status') { should eq 0 }
      its('stdout') { should match /ON/}
    end

    # Ensure that Cluster Status is Primary:
    describe command(mysql_cmd + "\"SHOW GLOBAL STATUS LIKE \'wsrep_cluster_status\';\"") do
      its('exit_status') { should eq 0 }
      its('stdout') { should match /Primary/}
    end

    # Ensure that all nodes (3) are in the cluster:
    describe command(mysql_cmd + "\"SHOW GLOBAL STATUS LIKE \'wsrep_cluster_size\';\"") do
      its('exit_status') { should eq 0 }
      its('stdout') { should match /3/}
    end

    # Ensure that clustercheck script reports OK status:
    describe command("clustercheck clustercheckuser CLUSTERCHECK_PWD") do
      its('exit_status') { should eq 0 }
      its('stdout') { should match /200 OK/}
      its('stdout') { should match /Cluster Node is synced/}
    end

    # Galera Cluster replication works over 4567:
    describe port(4567) do
      it { should be_listening }
      its('protocols') {should include 'tcp'}
    end

    # MySQL default connections port 3306 (both IPv4 and v6):
    describe port(3306) do
      it { should be_listening }
      its('protocols') {should include 'tcp6'}
    end

    # Xinetd for clusterchecks is using port 9200:
    describe port(9200) do
      it { should be_listening }
      its('protocols') {should include 'tcp6'}
    end

    # Ensure SELINUX is enabled (there is no dedicated resource yet):
    describe command("sestatus") do
      its('exit_status') { should eq 0 }
      its('stdout') { should match(/^SELinux status:                 enabled*./)}
    end

    # Ensure SELINUX mode is enforcing (there is no dedicated resource yet):
    describe command("sestatus") do
      its('exit_status') { should eq 0 }
      its('stdout') { should match(/^Current mode:                   enforcing*./)}
    end

end
