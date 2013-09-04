require 'spec_helper'

describe 'bluepill::simple_app' do
  let(:pre_condition) do
    <<PUPPET
#define bluepill::app(
#  $content,
#  $create_service,
#  $service_name,
#  $logfile,
#  $rotate_logs,
#  $logrotate_options,
#){
#}
PUPPET
  end

  let(:title) do 'app1' end
  let(:params) do
    {
      :start_command => 'startup -c "astr\'ing" \'foo\'',
      :user => 'u',
      :group => 'g',
      :pidfile => '/tmp/pid',
      :create_service => 'e',
      :service_name => 'f',
      :logfile => '/tmp/log',
      :rotate_logs => 'h',
      :logrotate_options => { 'rotate' => '2' },
    }
  end
  it 'should render config file' do
    content = <<CONTENT

Bluepill.application("app1") do |app|
  app.uid = "u"
  app.gid = "g"
  app.process("app1") do |process|
    process.start_command = "startup -c \\"astr'ing\\" 'foo'"
    process.daemonize = true
    process.pid_file = "/tmp/pid"
    process.stdout = process.stderr = "/tmp/log"
  end
end
CONTENT
    should contain_bluepill__app('app1').with({
      :content           => content,
      :create_service    => 'e',
      :service_name      => 'f',
      :logfile           => '/tmp/log',
      :rotate_logs       => 'h',
      :logrotate_options => { 'rotate' => '2' },
    })
  end

  # context 'all parameters are overridden' do
  #   let(:title) do 'app1' end
  #   let(:params) do
  #     {
  #       :source  => 'baz',
  #       :content => 'foobar',
  #       :create_service => true,
  #       :service_name => 'maservice',
  #       :rotate_logs => true,
  #       :logfile => '/q/thelog',
  #       :logrotate_options => {
  #         'compress' => false,
  #       },
  #     }
  #   end

  #   it do
  #     should contain_file('/b/app1.pill').with({
  #       :owner => 'root',
  #       :group => 'root',
  #       :mode  => '0644',
  #       :source => 'baz',
  #       :content => 'foobar',
  #     })
  #     should contain_service('maservice').with({
  #       :ensure => 'running',
  #       :enable => true,
  #     })
  #     should contain_file('/etc/init.d/maservice').with({
  #       :owner => 'root',
  #       :group => 'root',
  #       :mode  => '0755',
  #       :content => /bluepill_call\(\)\{\s*bluepill "app1" "\$\@"/,
  #     })
  #     should contain_logrotate__rule('bluepill-app1').with({
  #       :path => '/q/thelog',
  #       :compress => false,
  #       :missingok => false,
  #     })
  #   end
  # end

  # context 'create_service is false' do
  #   let(:title) do 'app1' end
  #   let(:params) do
  #     { 
  #       :create_service => false,
  #       :service_name => 'a'
  #     }
  #   end

  #   it do
  #      should_not contain_service('a')
  #      should_not contain_file('/etc/init.d/a')
  #   end
  # end

  # context 'rotate_logs is false' do
  #   let(:title) do 'app1' end
  #   let(:params) do {:rotate_logs => false } end
  #   it { should_not contain_logrotate__rule('bluepill-app1') }
  # end
end
