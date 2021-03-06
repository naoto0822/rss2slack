# config valid only for current version of Capistrano
lock "3.9.1"

APP_NAME = "rss2slack".freeze
GIT_URL = "https://github.com/naoto0822/rss2slack.git".freeze

set :application, "#{APP_NAME}"
set :repo_url, "#{GIT_URL}"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/#{APP_NAME}"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# rbenv
set :rbenv_custom_path, "/usr/local/rbenv"

# capistrano3/unicorn
set :unicorn_pid, -> { "/tmp/unicorn.pid" }
set :unicorn_config_path, -> { "/etc/unicorn/unicorn_conf.rb" }

after 'deploy:publishing', 'deploy:restart'
after 'deploy:finishing', 'deploy:enabled_service'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
  task :enabled_service do
    on roles(:app) do
      execute :sudo, :systemctl, "enable", "rss2slack"
    end
  end
end
