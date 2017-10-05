@app_name = "rss2slack"
@app_path = "/var/www/#{@app_name}"
preload_app true

worker_processes {{ dev_unicorn_worker_processes }} 
working_directory "#{@app_path}/current"

timeout {{ unicorn_timeout }}
listen "/tmp/unicorn.sock"
pid "/tmp/unicorn.pid"

stderr_path "/var/log/unicorn/#{@app_name}_stderr.log"
stdout_path "/var/log/unicorn/#{@app_name}_stdout.log"
