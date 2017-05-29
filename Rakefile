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
  task :local => ['env:local', 'db:local:start', 'unicorn:local:start']

  desc 'start api for dev'
  task :dev do
    # NOOP
  end

  desc 'start api for prod'
  task :prod do
    # NOOP
  end
end

namespace :unicorn do
  namespace :local do
    desc 'local unicorn start'
    task :start do
      sh 'bundle exec unicorn -E development -c ./etc/unicorn/unicorn.local.rb -D'
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
      sh 'bundle exec unicorn -E development -c /etc/unicorn/unicorn.dev.rb -D'
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
      sh 'bundle exec unicorn -E production -c /etc/unicorn/unicorn.prod.rb -D'
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
    sh 'mkdir -p ./var/log/rss2slack'
    sh 'mkdir -p ./var/log/unicorn'
    sh 'mkdir -p ./var/tmp'
    sh 'mkdir -p ./etc/unicorn'
    sh 'mkdir -p ./etc/rss2slack'
    sh 'cp -f ./conf/unicorn.local.rb ./etc/unicorn'
    sh 'cp -f ./deploy/rss2slack/conf.local.yml ./etc/rss2slack'
  end

  desc 'setting dev env'
  task :dev do
    sh 'mkdir -p /var/log/rss2slack'
    sh 'mkdir -p /var/log/unicorn'
    sh 'mkdir -p /var/tmp'
    sh 'mkdir -p /etc/unicorn'
    sh 'mkdir -p /etc/rss2slack'
    sh 'cp -f ./conf/unicorn.dev.rb /etc/unicorn'
    sh 'cp -f ./deploy/rss2slack/conf.dev.yml /etc/rss2slack'
  end
  
  desc 'setting prod env'
  task :prod do
    sh 'mkdir -p /var/log/rss2slack'
    sh 'mkdir -p /var/log/unicorn'
    sh 'mkdir -p /var/tmp'
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
    './etc/rss2slack/conf.local.yml'
  else
    nil
  end
end
