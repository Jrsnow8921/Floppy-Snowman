
set :stages, %w(production)
set :default_stage, "production"
require 'capistrano/ext/multistage'

require "bundler/capistrano"

set :rvm_type, :system
require "rvm/capistrano"

load "config/recipes/base"
load "config/recipes/check"
load "config/recipes/apache"
load "config/recipes/log_rotate"

server "172.16.12.7", :web, :app, :db, :primary => true

set :application, "Jsnow.pennunited.com"

# There is a problem with rb-fsevent and deploying
set :bundle_without, [:test, :development, :darwin]

set :user, "rails"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :copy
set :use_sudo, false

set :scm, :git
set :branch, :master
set :repository,  "git@github.com:Jrsnow8921/FlappyBird-master.git"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only last 5 releases

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

#If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

