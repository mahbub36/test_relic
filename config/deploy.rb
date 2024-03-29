# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'First New Relic Rails'
#set :repo_url, 'git@example.com:me/my_repo.git'
set :rvm_ruby_string, 'ruby-1.9.3-p392'
set :rvm_type, :system
set :bundle_cmd, "bundle"
set :rake, 'bundle exec rake'

# We need to run this after our collector mongrels are up and running
# This goes out even if the deploy fails, sadly
after "deploy", "newrelic:notice_deployment"
after "deploy:update", "newrelic:notice_deployment"
after "deploy:migrations", "newrelic:notice_deployment"
after "deploy:cold", "newrelic:notice_deployment"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
