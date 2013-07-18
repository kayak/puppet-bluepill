# == Class: bluepill
#
# Full description of class bluepill here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { bluepill:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Kayak
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
}
