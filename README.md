puppet-bluepill
===============

[![Build Status](https://travis-ci.org/kayakco/puppet-bluepill.png)](https://travis-ci.org/kayakco/puppet-bluepill)

A Puppet module for installing [Bluepill](https://github.com/arya/bluepill).

Examples
--------

The following will install rubygems and the bluepill gem, create the /var/run/bluepill and /etc/bluepill directories, and configure rsyslog to log bluepill messages to /var/log/bluepill

    include bluepill

If you don't use rsyslog, you can disable rsyslog rule generation like this:

    class { 'bluepill':
       use_rsyslog => false,
    }

If you do not want this module to install rubygems, you can disable with:

    class { 'bluepill':
      rubygems_class => 'UNDEFINED',
    }

If you have a process you want to quickly daemonize, you can use the bluepill::simple_app type, which will auto-generate a bluepill config file and init script.

    blupill::simple_app { 'my_java_app':
      start_command  => '/usr/bin/java7 -jar /home/appl/my_java_app.jar',
      user           => 'appl',
      group          => 'users',
      create_service => true,
      service_name   => 'my-app', # Will create an init script at /etc/init.d/my-app
      logfile        => '/var/log/myapp',
      rotate_logs    => true,
      logrotate-options => {  # Any valid logrotate::rule options can be supplied here
        'rotate' => 4,
      },
    }

