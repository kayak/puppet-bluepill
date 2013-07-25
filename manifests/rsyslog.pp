class bluepill::rsyslog(
  $log_path = '/var/log/bluepill',
  $logrotate_options = {},
){

  file { '/etc/rsyslog.d/45-bluepill.conf':
    ensure  => present,
    content => template('bluepill/bluepill-rsyslog.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  create_resources('logrotate::rule',
                    { 'bluepill' => merge($bluepill::logrotate_defaults,
                                          $logrotate_options)},
                    { 'path' => $log_path })

  Logrotate::Rule <||> {
    notify => Exec['restart-rsyslog'],
  }

  exec { 'restart-rsyslog':
    path        => ['/bin','/usr/bin','/sbin','/usr/sbin'],
    command     => 'service rsyslog restart',
    refreshonly => true,
  }
}
