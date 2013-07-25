define bluepill::app(
  $source = undef,
  $content = undef,
  $create_service = true,
  $service_name = "bluepill-${title}",
  $rotate_logs = true,
  $logfile = "/var/log/${title}",
  $logrotate_options = {},
){

  $appname = $title
  $conffile = "${bluepill::confdir}/${appname}.pill"

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
