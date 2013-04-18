# -*- encoding : utf-8 -*-
require 'rvm'
require 'rvm/capistrano'
require 'bundler/capistrano'

set :application, "icounter"
set :user,        "robot"
server "crtweb.ru", :app, :web, :db, :primary => true
set :rails_env, "production"
set :deploy_to, "/srv/sites/#{application}"
set :use_sudo, false
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :rvm_type, :user

set :scm, :git
set :repository,  "git@crtweb.ru:icounter.git"
set :branch, "master"
set :deploy_via, :remote_cache

# after 'deploy:update_code', :roles => :app do
#   run "rm -f #{current_release}/config/database.yml"
#   run "mv #{current_release}/config/database.yml.template #{current_release}/config/database.yml"
#   run "ln -s #{deploy_to}/shared/production.sqlite3 #{current_release}/db/"
# end

namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end

  task :start do
    run "cd #{deploy_to}/current; bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
  end

  task :stop do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end
