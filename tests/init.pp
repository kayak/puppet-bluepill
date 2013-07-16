class { 'bluepill':
   apps => {
     'app1' => {
       content => "
Bluepill.application('app1') do |app|
  app.process('main') do |process|
    process.start_command = '/bin/sleep 5',
    process.pid_file = '/var/run/app1.pid',
  end
end
",
     }
   }
}

