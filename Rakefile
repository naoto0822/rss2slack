require 'rake'

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
  ENV_LOCAL = 'local'.freeze
  ENV_DEV = 'development'.freeze
  ENV_PROD = 'production'.freeze

  desc 'start worker for local'
  task :local do
    ENV['env'] = ENV_LOCAL
    sh 'bundle exec ruby src/exec/worker.rb'
  end

  desc 'start worker for dev'
  task :dev do
    ENV['env'] = ENV_DEV
    sh 'bundle exec ruby src/exec/worker.rb'
  end

  desc 'start worker for prod'
  task :prod do
    ENV['env'] = ENV_PROD
    sh 'bundle exec ruby src/exec/worker.rb'
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
  desc 'unicorn for local'
  task :unicorn_local do
    sh 'bundle exec unicorn -E development -c ./conf/unicorn.local.rb -D'
  end

  desc 'unicorn for dev'
  task :dev do
    sh 'bundle exec unicorn -E development -c ./conf/unicorn.dev.rb -D'
  end

  desc 'unicorn for prod'
  task :prod do
    sh 'bundle exec unicorn -E production -c ./conf/unicorn.prod.rb -D'
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
tasl :lint do
  sh 'bundle exec rubocop'
end

private

def bundle_install()
  sh 'bundle install --path vendor/bundle'
end
