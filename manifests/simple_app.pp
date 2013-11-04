# == Define: bluepill:app
#
# An abstraction for configuring Bluepill apps.
# Supply user, group, pidfile, and other options and a
# default bluepill config file will be automatically
# generated from a template.
#
# $config_source and $config_content options are provided,
# in case users need to make modifications to the template.
#
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
  $config_content = undef,
  $config_source  = undef,
){

  bluepill::app { $title:
    create_service    => $create_service,
    service_name      => $service_name,
    logfile           => $logfile,
    rotate_logs       => $rotate_logs,
    logrotate_options => $logrotate_options,
  }

  if $config_content != undef {
    Bluepill::App[$title] {
      content => $config_content,
    }
  } elsif $config_source != undef {
    Bluepill::App[$title] {
      source  => $config_source,
    }
  } else {
    $appname = $title
    Bluepill::App[$title] {
      content => template('bluepill/simple_app.erb')
    }
  }

}
