require 'spec_helper'

describe 'bluepill::app' do
  let(:pre_condition) do
    <<PUPPET
class bluepill {
  $confdir = '/b'
  $logrotate_defaults = {
    'compress' => true,
    'missingok' => false,
  }
}
include bluepill
PUPPET
  end

  context 'all parameters are overridden' do
    let(:title) do 'app1' end
    let(:params) do
      {
        :source  => 'baz',
        :content => 'foobar',
        :create_service => true,
        :service_name => 'maservice',
        :rotate_logs => true,
        :logfile => '/q/thelog',
        :logrotate_options => {
          'compress' => false,
        },
      }
    end

    it do
      should contain_file('/b/app1.pill').with({
        :owner => 'root',
        :group => 'root',
        :mode  => '0644',
        :source => 'baz',
        :content => 'foobar',
      })
      should contain_service('maservice').with({
        :ensure => 'running',
        :enable => true,
      })
      should contain_file('/etc/init.d/maservice').with({
        :owner => 'root',
        :group => 'root',
        :mode  => '0755',
        :content => /bluepill_call\(\)\{\s*bluepill "app1" "\$\@"/,
      })
      should contain_logrotate__rule('bluepill-app1').with({
        :path => '/q/thelog',
        :compress => false,
        :missingok => false,
      })
    end
  end

  context 'create_service is false' do
    let(:title) do 'app1' end
    let(:params) do
      { 
        :create_service => false,
        :service_name => 'a'
      }
    end

    it do
       should_not contain_service('a')
       should_not contain_file('/etc/init.d/a')
    end
  end

  context 'rotate_logs is false' do
    let(:title) do 'app1' end
    let(:params) do {:rotate_logs => false } end
    it { should_not contain_logrotate__rule('bluepill-app1') }
  end
end
