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
  task :local => ['env:local', 'db:local:start', 'nginx:local:start', 'unicorn:local:start']

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
  namespace :local do
    desc 'db start'
    task :start do
      sh 'mysql.server start'
    end

    desc 'setup user, database'
    task :setup do
      sh 'mysql -u root < ./scripts/setup.sql'
    end

    desc 'create table to db'
    task :create_tables => ['env:local'] do
      user = ENV['db_user']
      pass = ENV['db_password']
      sh "mysql -u#{user} rss2slack_u -p#{pass} < ./scripts/create.sql"
    end
  end

  namespace :dev do

  end

  namespace :prod do

  end
end

namespace :bootstrap do
  desc 'setting local env'
  task :local do
    sh 'mkdir -p /var/log/rss2slack'
    sh 'mkdir -p /var/log/unicorn'
    sh 'mkdir -p /var/log/nginx'
    sh 'mkdir -p /tmp'
    sh 'mkdir -p /etc/unicorn'
    sh 'mkdir -p /etc/rss2slack'
    sh 'cp -f ./conf/unicorn.local.rb /etc/unicorn'
    sh 'cp -f ./conf/nginx.local.conf /usr/local/etc/nginx/servers/rss2slack.conf'
    sh 'cp -f ./deploy/rss2slack/conf.local.yml /etc/rss2slack'
  end

  desc 'setting dev env'
  task :dev do
    sh 'sudo mkdir -p /var/log/rss2slack'
    sh 'sudo mkdir -p /var/log/unicorn'
    sh 'sudo mkdir -p /var/log/nginx'
    sh 'sudo mkdir -p /etc/unicorn'
    sh 'sudo mkdir -p /etc/rss2slack'
    sh 'sudo cp -f ./conf/unicorn.dev.rb /etc/unicorn'
    sh 'sudo cp -f ./deploy/rss2slack/conf.dev.yml /etc/rss2slack'
  end
  
  desc 'setting prod env'
  task :prod do
    sh 'mkdir -p /var/log/rss2slack'
    sh 'mkdir -p /var/log/unicorn'
    sh 'mkdir -p /tmp'
    sh 'mkdir -p /etc/unicorn'
    sh 'mkdir -p /etc/rss2slack'
    sh 'cp -f ./conf/unicorn.prod.rb /etc/unicorn'
    sh 'cp -f ./deploy/rss2slack/conf.prod.yml /etc/rss2slack'
  end
end

namespace :env do
  desc 'set local env'
  task :local do
    ENV['env'] = ENV_LOCAL
    ENV['db_user'] = conf_file['mysql']['username']
    ENV['db_password'] = conf_file['mysql']['password']
  end

  desc 'set dev env'
  task :dev do
    ENV['env'] = ENV_DEV
    ENV['db_user'] = conf_file['mysql']['username']
    ENV['db_password'] = conf_file['mysql']['password']
  end

  desc 'set prod env'
  task :prod do
    ENV['env'] = ENV_PROD
    ENV['db_user'] = conf_file['mysql']['username']
    ENV['db_password'] = conf_file['mysql']['password']
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

namespace :test do
  desc 'exec rspec'
  task :spec do
    sh 'bundle exec rspec spec/'
  end

  desc 'lint'
  task :lint do
    sh 'bundle exec rubocop'
  end
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

def conf_file
  path = conf_path
  if path.nil?
    raise RuntimeError, 'not set env.'
  end
  YAML.load_file(path)
rescue => e
  raise ArgumentError, "#{e.class}, #{e.backtrace}"
end

# TODO: fix prod, dev path
def conf_path
  env = ENV['env']
  case env
  when 'production'
    '/etc/rss2slack/conf.prod.yml'
  when 'development'
    '/etc/rss2slack/conf.dev.yml'
  when 'local'
    '/etc/rss2slack/conf.local.yml'
  else
    nil
  end
end
