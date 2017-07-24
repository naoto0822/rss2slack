require 'rake'
require 'yaml'

ENV_LOCAL = 'local'.freeze
ENV_DEV = 'development'.freeze
ENV_PROD = 'production'.freeze

# !!!!!!!!!!!!!!
# For Production
# !!!!!!!!!!!!!!
# TODO:
task :default => [:bundle_install, :test]

namespace :worker do
  namespace :feed do
    desc 'start worker for local'
    task :local => ['env:local', 'db:local:start'] do
      sh 'bundle exec ruby src/exec/feed_worker.rb'
    end

    desc 'start worker for dev'
    task :dev => ['env:dev'] do
      sh 'bundle exec ruby src/exec/feed_worker.rb'
    end

    desc 'start worker for prod'
    task :prod => ['env:prod'] do
      sh 'bundle exec ruby src/exec/feed_worker.rb'
    end
  end

  namespace :article do
    desc 'start article worker for local'
    task :local => ['env:local', 'db:local:start'] do
      sh 'bundle exec ruby src/exec/article_worker.rb'
    end

    desc 'start article worker for dev'
    task :dev => ['env:dev'] do
      sh 'bundle exec ruby src/exec/article_worker.rb'
    end

    desc 'start article worker for prod'
    task :prod => ['env:prod'] do
      sh 'bundle exec ruby src/exec/article_worker.rb'
    end
  end
end

namespace :api do
  desc 'start api for local'
  task :local => ['env:local', 'db:start', 'nginx:start', 'unicorn:start']

  desc 'start api for dev'
  task :dev do
    # NOOP
  end

  desc 'start api for prod'
  task :prod do
    # NOOP
  end
end

namespace :nginx do
  desc 'start nginx'
  task :start do
    sh 'systemctl start nginx' if is_linux?
    sh 'sudo nginx' if is_osx?
  end

  desc 'stop nginx'
  task :stop do
    sh 'systemctl stop nginx' if is_linux?
    sh 'sudo nginx -s stop' if is_osx?
  end

  desc 'restart nginx'
  task :restart do
    sh 'systemctl reload nginx' if is_linux?
    sh 'sudo nginx -s reload' if is_osx?
  end
end

namespace :unicorn do
  desc 'start unicorn'
  task :start do
    env = ENV['env']
    file_opt = "unicorn.#{env}.rb"
    env_opt = unicorn_env
    sh "bundle exec unicorn -E #{env_opt} -c /etc/unicorn/#{file_opt} -D"
  end

  desc 'stop unicorn'
  task :stop do
    sh 'kill -QUIT `cat /tmp/unicorn.pid`'
  end

  desc 'restart unicorn'
  task :restart => ['unicorn:stop', 'unicorn:start']
end

namespace :db do
  desc 'start db'
  task :start do
    sh 'systemctl start mysqld' if is_linux?
    sh 'mysql.server start' if is_osx?
  end

  desc 'stop db'
  task :stop do
    sh 'systemctl stop mysqld' if is_linux?
    sh 'mysql.server stop' if is_osx?
  end

  desc 'setup user, database'
  task :setup do
    sh 'sh ./scripts/create_mysql_root_user.sh'
    sh 'sh ./private/rss2slack/alter_db_root_pass.sh'
    sh 'mysql < ./private/rss2slack/setup_db.sql'
    sh 'mysql rss2slack < ./scripts/create_tables.sql'
  end

  desc 'create tables to db'
  task :create_tables do
    user = ENV['db_user']
    pass = ENV['db_password']
    sh "mysql -u#{user} rss2slack_u -p#{pass} < ./scripts/create.sql"
  end
end

namespace :bootstrap do
  desc 'setting local env'
  task :local do
    sh 'sudo mkdir -p /var/log/rss2slack'
    sh 'sudo chown -R naoto /var/log/rss2slack'
    sh 'sudo mkdir -p /var/log/unicorn'
    sh 'sudo chown -R naoto /var/log/unicorn'
    sh 'sudo mkdir -p /var/log/nginx'
    sh 'sudo chown -R nginx:nginx /var/log/nginx'
    sh 'sudo mkdir -p /etc/unicorn'
    sh 'sudo mkdir -p /etc/rss2slack'
    sh 'sudo cp -f ./conf/unicorn.local.rb /etc/unicorn'
    sh 'sudo cp -f ./conf/nginx.local.conf /usr/local/etc/nginx/servers/rss2slack.conf'
    sh 'sudo cp -f ./private/rss2slack/conf.local.yml /etc/rss2slack'
  end

  desc 'setting dev env'
  task :dev do
    sh 'sudo mkdir -p /var/log/rss2slack'
    sh 'sudo chown -R naoto:wheel /var/log/rss2slack'
    sh 'sudo mkdir -p /var/log/unicorn'
    sh 'sudo chown -R naoto:wheel /var/log/unicorn'
    sh 'sudo mkdir -p /var/log/nginx'
    sh 'sudo chown -R nginx:nginx /var/log/nginx'
    sh 'sudo mkdir -p /etc/unicorn'
    sh 'sudo mkdir -p /etc/rss2slack'
    sh 'sudo cp -f ./conf/unicorn.development.rb /etc/unicorn'
    sh 'sudo cp -f ./conf/nginx.development.conf /etc/nginx/conf.d/rss2slack.conf'
    sh 'sudo cp -f ./conf/my.cnf /etc'
    sh 'sudo cp -f ./private/rss2slack/conf.development.yml /etc/rss2slack'
  end
  
  desc 'setting prod env'
  task :prod do
    sh 'mkdir -p /var/log/rss2slack'
    sh 'mkdir -p /var/log/unicorn'
    sh 'mkdir -p /tmp'
    sh 'mkdir -p /etc/unicorn'
    sh 'mkdir -p /etc/rss2slack'
    sh 'cp -f ./conf/unicorn.production.rb /etc/unicorn'
    sh 'cp -f ./private/rss2slack/conf.production.yml /etc/rss2slack'
  end
end

namespace :env do
  desc 'set local env'
  task :local do
    ENV['env'] = ENV_LOCAL
    set_db_user
  end

  desc 'set dev env'
  task :dev do
    ENV['env'] = ENV_DEV
    set_db_user
  end

  desc 'set prod env'
  task :prod do
    ENV['env'] = ENV_PROD
    set_db_user
  end

  desc 'exec bundle install'
  task :bundle_install do
    bundle_install
  end

  desc 'update bundler'
  task :update_bundler do
    sh 'gem install bundler'
    sh 'gem update bundler'
  end
end

desc 'exec rspec'
task :spec do
  sh 'bundle exec rspec spec/'
end

desc 'lint'
task :lint do
  sh 'bundle exec rubocop'
end

private

def bundle_install
  sh 'bundle install --path vendor/bundle'
end

def what_os
  RUBY_PLATFORM
end

def is_osx?
  what_os.include?('darwin')
end

def is_linux?
  what_os.include?('linux')
end

def unicorn_env
  env = ENV['env']
  case env
  when 'production'
    'production'
  when 'development'
    'development'
  when 'local'
    'development'
  else
    nil
  end
end

def set_db_user
  ENV['db_user'] = conf_file['mysql']['username']
  ENV['db_password'] = conf_file['mysql']['password']
end

def conf_file
  path = conf_path
  if path.nil?
    raise RuntimeError, 'not set env.'
  end
  YAML.load_file(path)
rescue => e
  raise ArgumentError, "#{e.class}, #{e.backtrace}"
end

def conf_path
  env = ENV['env']
  "/etc/rss2slack/conf.#{env}.yml"
end
