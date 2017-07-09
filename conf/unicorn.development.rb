@dir = File.expand_path(File.dirname(__FILE__) + '/../')

worker_processes 1 
working_directory @dir
timeout 300
listen 80
pid "#{@dir}/var/tmp/unicorn.pid"
stderr_path "#{@dir}/var/log/unicorn.stderr.log"
stdout_path "#{@dir}/var/log/unicorn.stdout.log"

