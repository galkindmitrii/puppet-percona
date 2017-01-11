require 'spec_helper_acceptance'

describe 'basic galera' do
  context 'default parameters' do
    it 'should work with no errors' do
      pp= <<-EOS
class { 'percona':
    manage_repo   => true,
    master   => true,
    mysql_cluster_servers   => ['192.168.99.101'],
    root_password   => 'AVERYLONGPASSWORD',
    wsrep_sst_method    => 'xtrabackup-v2',
}
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe port(3306) do
      it { is_expected.to be_listening.with('tcp') }
    end

    describe port(4567) do
      it { is_expected.to be_listening.with('tcp') }
    end
  end
end
