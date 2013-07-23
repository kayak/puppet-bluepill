# == Class: bluepill
#
# Install bluepill gem and configuration and process directories on
# the node.
#
# === Parameters
#
# [*confdir*]
#
# Directory where pill files should be stored.
#
# [*apps*]
#
# Hash definitions of bluepill::app resources that should be instaleld
#
# [*app_defaults*]
#
# Defaults for the app resources
#
# [*use_rsyslog*]
#
# Configure rsyslog to log Bluepill messages to /var/log/bluepill
#
# [*logrotate_defaults*]
#
# Default parameters for /var/log/bluepill log rotation.
#
class bluepill(
  $confdir            = '/etc/bluepill',
  $apps               = {},
  $app_defaults       = {},
  $use_rsyslog        = true,
  $logrotate_defaults = {
    'rotate'        => 4,
    'rotate_every'  => 'day',
    'ifempty'       => false,
    'missingok'     => true,
    'delaycompress' => true,
    'compress'      => true,
    'postrotate'    => 'reload rsyslog >/dev/null 2>&1 || true',
  },
  $rubygems_class     = 'r9util::rubygems',
){

  $supported = {
    'CentOS' => ['6'],
    'Ubuntu' => ['12'],
  }
  ensure_supported($supported,true)

  package { 'bluepill': provider => 'gem' }

  if $use_rsyslog {
    include bluepill::rsyslog
  }

  file { ['/var/run/bluepill',$confdir]:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  create_resources('bluepill::app',$apps,$app_defaults)

  if $rubygems_class != 'UNDEFINED' {
    include $rubygems_class

    Bluepill::App <||> {
      require => Class[$rubygems_class]
    }
  }
}
