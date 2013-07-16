require 'spec_helper'

describe 'bluepill' do
  let(:facts) do
    {
      :operatingsystem => 'CentOS',
      :operatingsystemrelease => '6.3'
    }
  end

  context 'default parameters' do
    it do
      should contain_bluepill__rsyslog
      should contain_package('bluepill').with({ :provider => 'gem' })
      should contain_file('/var/run/bluepill')
    end
  end

  context 'without rsyslog' do
    let(:params) do
      { :use_rsyslog => false }
    end

    it { should_not contain_bluepill__rsyslog }
  end

  context 'should declare apps' do
    let(:params) do
      {
        :apps => {
          'app1' => {
            'rotate_logs' => true,
          },
          'app2' => {
            'service_name' => 'foo',
          }
        },
        :app_defaults => {
          'create_service' => true,
          'rotate_logs' => false,
        }
      }
    end

    it do
      should contain_bluepill__app('app1').with({
        :service_name => 'bluepill-app1',
        :rotate_logs => true,
        :create_service => true,
      })
      should contain_bluepill__app('app2').with({
        :service_name => 'foo',
        :rotate_logs => false,
        :create_service => true,
      })
    end
  end
end
