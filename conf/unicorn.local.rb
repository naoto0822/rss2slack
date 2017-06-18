@dir = "/Users/naoto/develop/ruby/app/rss2slack"
@app_name = "rss2slack"
preload_app true

worker_processes 1 
working_directory @dir

timeout 300
listen "/tmp/unicorn.sock"
pid "/tmp/unicorn.pid"

stderr_path "/var/log/unicorn/#{@app_name}_stderr.log"
stdout_path "/var/log/unicorn/#{@app_name}_stdout.log"
