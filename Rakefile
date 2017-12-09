require 'rake'
require 'yaml'

task :default => [:bundle_install, :test]

namespace :worker do
  namespace :feed do
    desc 'start feed worker'
    task :start => ['db:start'] do
      sh 'bundle exec ruby ./src/exec/feed_worker.rb'
    end
  end

  namespace :article do
    desc 'start article worker'
    task :start => ['db:start'] do
      sh 'bundle exec ruby ./src/exec/article_worker.rb'
    end  
  end
end

namespace :app do
  desc 'start app'
  task :start => [
    'db:start',
    'unicorn:restart',
    'nginx:start'
  ]
end

namespace :nginx do
  desc 'start nginx'
  task :start do
    sh 'sudo systemctl start nginx'
  end

  desc 'stop nginx'
  task :stop do
    sh 'sudo systemctl stop nginx'
  end

  desc 'restart nginx'
  task :restart do
    sh 'sudo systemctl restart nginx'
  end
end

namespace :unicorn do
  desc 'start unicorn'
  task :start do
    env = conf_file()["app"]["env"]
    if env.nil? || env.empty?
      raise ArgumentError, 'required set env.'
    end
    env_opt = unicorn_env(env)
    sh "bundle exec unicorn -E #{env_opt} -c /etc/unicorn/unicorn_conf.rb -D"
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
    sh 'sudo systemctl start mysqld'
  end

  desc 'stop db'
  task :stop do
    sh 'sudo systemctl stop mysqld'
  end

  desc 'restart db'
  task :restart do
    sh 'sudo systemctl restart mysqld'
  end

  desc 'setup database, user, table'
  task :setup do
    sh 'sh ./scripts/setup_mysql.sh'
  end
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

def unicorn_env(env)
  case env
  when 'prod'
    return 'production'
  when 'staging'
    return 'development'
  when 'dev'
    return 'development'
  else
    nil
  end
end

def conf_file
  path = conf_path
  if path.nil?
    raise RuntimeError, 'not set conf_file'
  end
  YAML.load_file(path)
rescue => e
  raise ArgumentError, "#{e.class}, #{e.backtrace}"
end

def conf_path
  "/etc/rss2slack/rss2slack_conf.yml"
end
