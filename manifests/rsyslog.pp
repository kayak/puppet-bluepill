class bluepill::rsyslog(
  $log_path = '/var/log/bluepill',
  $logrotate_options = {},
){

  file { '/etc/rsyslog.d/95-bluepill.conf':
    ensure  => present,
    content => template('bluepill/95-bluepill.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  create_resources('logrotate::rule',
                    { 'bluepill' => merge($bluepill::logrotate_defaults,
                                          $logrotate_options)},
                    { 'path' => $log_path })
}
