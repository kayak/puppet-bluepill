# == Define: bluepill::app
#
# An abstraction for configuring Bluepill apps. Supply a source
# path or template for a Bluepill config file, and (in addition to
# copying the config file into /etc/bluepill) this type can:
#
#   - create an init script for the app
#   - ensure the app is running (using Puppet's service type)
#   - rotate the app's logs
#
# === Parameters
#
# [*title*] A unique name for this app.
#
# [*source*]
#   Puppet URL pointing to source of the app's Bluepill
#   config file, as in Puppet's file type.
#
# [*content*]
#   String representing content of the app's Bluepill config
#   file, as in Puppet's file type. Must be supplied if $source is not.
#
# [*create_service*]
#   When true, an init script will be created for this bluepill app,
#   and it will be declared as a Puppet service.
#
# [*rotate_logs*]
#   Whether to rotate the logs for this app.
#
# [*logfile*]
#   Path to the app's logfile. Only matters if $rotate_logs is true.
#
# [*logrotate_options*]
#   Set any desired logrotate options here.
#
define bluepill::app(
  $source            = undef,
  $content           = undef,
  $create_service    = true,
  $service_name      = "bluepill-${title}",
  $logfile           = "/var/log/${title}",
  $rotate_logs       = false,
  $logrotate_options = {},
){

  include bluepill

  $appname = $title
  $conffile = "${bluepill::confdir}/${appname}.pill"

  if $source == undef and $content == undef {
    fail('Either source or content parameter must be supplied!')
  }

  file { $conffile:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => $source,
    content => $content,
  }

  if $create_service {
    file { "/etc/init.d/${service_name}":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('bluepill/init-script.erb'),
    }
    ->
    service { $service_name:
      ensure    => running,
      enable    => true,
      subscribe => File[$conffile],
    }
  }

  $rotate_opts = merge($bluepill::logrotate_defaults,
                        $logrotate_options)

  if $rotate_logs {
    create_resources('logrotate::rule',
                      { "bluepill-${appname}" => $rotate_opts },
                      { 'path' => $logfile })
  }
}
