define bluepill::simple_app(
  $start_command,
  $user           = 'root',
  $group          = 'root',
  $pidfile        = "/var/run/bluepill-${title}.pid",
  $create_service = true,
  $service_name   = "bluepill-${title}",
  $logfile        = "/var/log/${title}",
  $rotate_logs    = false,
  $logrotate_options = {},
){

  $appname = $title
  $config  = template('bluepill/simple_app.erb')

  bluepill::app { $title:
    content           => $config,
    create_service    => $create_service,
    service_name      => $service_name,
    logfile           => $logfile,
    rotate_logs       => $rotate_logs,
    logrotate_options => $logrotate_options,
  }
}
