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

  context 'set config_content' do
    let (:title) do 'app1' end
    let (:params) do
      {
        :start_command => 'foo',
        :config_content => 'SOMECONTENT'
      }
    end

    it {
      should contain_bluepill__app('app1').with({
        :content => 'SOMECONTENT',
      })
    }
  end

  context 'set config_source' do
    let (:title) do 'app1' end
    let (:params) do
      {
        :start_command => 'foo',
        :config_source => 'puppet:///modules/FOO'
      }
    end

    it {
      should contain_bluepill__app('app1').with({
        :source => 'puppet:///modules/FOO',
      })
    }
  end

end
