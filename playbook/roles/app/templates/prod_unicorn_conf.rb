# /var/www/lib
@dir = ENV["HOME"] + "/rss2slack"
@app_name = "rss2slack"
preload_app true

worker_processes {{ prod_unicorn_worker_processes }} 
working_directory @dir

timeout {{ unicorn_timeout }}
listen "/tmp/unicorn.sock"
pid "/tmp/unicorn.pid"

stderr_path "/var/log/unicorn/#{@app_name}_stderr.log"
stdout_path "/var/log/unicorn/#{@app_name}_stdout.log"
