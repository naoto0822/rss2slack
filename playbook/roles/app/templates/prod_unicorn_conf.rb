# /var/www/lib
@app_name = "rss2slack"
@dir = "/var/www/#{@app_name}"
preload_app true

worker_processes {{ prod_unicorn_worker_processes }} 
working_directory @dir

timeout {{ unicorn_timeout }}
listen "/tmp/unicorn.sock"
pid "/tmp/unicorn.pid"

stderr_path "/var/log/unicorn/#{@app_name}_stderr.log"
stdout_path "/var/log/unicorn/#{@app_name}_stdout.log"
