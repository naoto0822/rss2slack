@app_name = "rss2slack"
@app_path = "/var/www/#{@app_name}"
preload_app true

worker_processes {{ staging_unicorn_worker_processes }}
working_directory "#{@app_path}/current"

timeout {{ unicorn_timeout }}
listen "/tmp/unicorn.sock"
pid "/tmp/unicorn.pid"

stderr_path "/var/log/unicorn/#{@app_name}_stderr.log"
stdout_path "/var/log/unicorn/#{@app_name}_stdout.log"

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
