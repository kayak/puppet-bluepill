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
      should include_class('r9util::rubygems')
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

  context 'with UNDEFINED rubygems class' do
    let(:params) do
      { :rubygems_class => 'UNDEFINED' }
    end

    it do
      should_not include_class('r9util::rubygems')
      should_not include_class('UNDEFINED')
    end
  end

  context 'with custom rubygems class' do
    let(:pre_condition) do "class foo{}" end
    let(:params) do
      { :rubygems_class => 'foo' }
    end
    it do
      should include_class('foo')
    end
  end
end
