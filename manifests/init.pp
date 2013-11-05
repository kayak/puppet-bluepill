# == Class: bluepill
#
# Install bluepill gem, create and configuration and pidfile
# directories.
#
# === Parameters
#
# [*confdir*]
#
# Directory where pill files should be stored.
#
# [*apps*]
#
# Hash definitions of bluepill::app resources that should be created.
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
# Default parameters to the logrotate::rule type (for app and bluepill
# log rotation.
#
# [*rubygems_class*]
#
# Class to require before installing the bluepill gem. Set to 'UNDEFINED'
# to not require any class.
#
class bluepill(
  $confdir            = '/etc/bluepill',
  $use_rsyslog        = true,
  $logrotate_defaults = {
    'rotate'        => 2,
    'rotate_every'  => 'day',
    'copytruncate'  => true,
    'ifempty'       => true,
    'missingok'     => true,
    'delaycompress' => false,
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

  Bluepill::App <||> {
    require => Package['bluepill']
  }

  if $rubygems_class != 'UNDEFINED' {
    include $rubygems_class

    Package['bluepill'] {
      require => Class[$rubygems_class]
    }
  }
}
