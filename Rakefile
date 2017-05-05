require 'rake'
require 'yaml'

ENV_LOCAL = 'local'.freeze
ENV_DEV = 'development'.freeze
ENV_PROD = 'production'.freeze

task :default => [:bundle_install, :test]

namespace :env do
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

namespace :worker do
  namespace :feed do
    desc 'start worker for local'
    task :local do
      ENV['env'] = ENV_LOCAL
      ENV['incoming_webhooks_url'] = private_conf_file['slack']['incoming_webhooks_url']
      sh 'bundle exec ruby src/exec/feed_worker.rb'
    end

    desc 'start worker for dev'
    task :dev do
      ENV['env'] = ENV_DEV
      ENV['incoming_webhooks_url'] = private_conf_file['slack']['incoming_webhooks_url']
      sh 'bundle exec ruby src/exec/worker.rb'
    end

    desc 'start worker for prod'
    task :prod do
      ENV['env'] = ENV_PROD
      ENV['incoming_webhooks_url'] = private_conf_file['slack']['incoming_webhooks_url']
      sh 'bundle exec ruby src/exec/worker.rb'
    end
  end

  namespace :article do

  end
end

namespace :api do
  desc 'start api for local'
  task :local do

  end

  desc 'start api for dev'
  task :dev do

  end

  desc 'start api for prod'
  task :prod do

  end
end

namespace :unicorn do
  namespace :local do
    desc 'local unicorn start'
    task :start do
      sh 'bundle exec unicorn -E development -c ./conf/unicorn.local.rb -D'
    end

    desc 'local unicorn stop'
    task :stop do
      sh 'kill -QUIT `cat ./var/tmp/unicorn.pid`'
    end

    desc 'local unicorn restart'
    task :restart => ['unicorn:local:stop', 'unicorn:local:start']
  end

  namespace :dev do
    desc 'dev unicorn start'
    task :start do
      sh 'bundle exec unicorn -E development -c ./conf/unicorn.dev.rb -D'
    end

    desc 'dev unicorn stop'
    task :stop do
      sh 'kill -QUIT `cat /var/tmp/unicorn.pid`'
    end

    desc 'dev unicorn restart'
    task :restart => ['unicorn:dev:stop', 'unicorn:dev:start']
  end

  namespace :prod do
    desc 'prod unicorn start'
    task :start do
      sh 'bundle exec unicorn -E production -c ./conf/unicorn.prod.rb -D'
    end

    desc 'prod unicorn stop'
    task :stop do
      sh 'kill -QUIT `cat /var/tmp/unicorn.pid`'
    end

    desc 'prod unicorn restart'
    task :restart => ['unicorn:prod:stop', 'unicorn:prod:start']
  end
end

namespace :db do
  desc 'setup user, database'
   task :setup do
    sh 'mysql -u root < ./scripts/setup.sql'
  end

  desc 'create table to db'
  task :create_tables do
    sh 'mysql -u rss2slack_u -p < ./scripts/create.sql'
  end
end

desc 'test'
task :test => [:bootstrap] do
  sh 'bundle exec rspec spec/'
end

desc 'launch middleware'
task :bootstrap do
  sh 'sh ./scripts/bootstrap.sh'
end

desc 'create var/ dir'
task :create_var do
  sh 'mkdir -p ./var/log/rss2slack'
  sh 'mkdir -p ./var/tmp'
end

desc 'lint'
task :lint do
  sh 'bundle exec rubocop'
end

private

def bundle_install()
  sh 'bundle install --path vendor/bundle'
end

def private_conf_file
  path = private_conf_path
  if path.nil?
    raise RuntimeError, 'not set env.'
  end
  YAML.load_file(path)
rescue => e
  raise ArgumentError, "#{e.class}, #{e.backtrace}"
end

# TODO: fix prod, dev path
def private_conf_path
  env = ENV['env']
  case env
  when 'production'
    './deploy/rss2slack/private_conf.local.yml'
  when 'development'
    './deploy/rss2slack/private_conf.dev.yml'
  when 'local'
    './deploy/rss2slack/private_conf.local.yml'
  else
    nil
  end
end
