set :stages, %w(production production-t9 production-t18 production-t19)
set :default_stage, "none"

set :whenever_command, "bundle exec whenever"
set :whenever_environment, defer { stage }

# require 'capistrano/ext/multistage'
require "bundler/capistrano"

set :application, "dusoleil"
set :repository,  "https://github.com/gentle0219/test-dusoleil.git"
set :scm, :git

set :user, :dusoleil
set :ssh_options, { :forward_agent => true }
set :deploy_to, "/var/www/dusoleil2"
set :deploy_via, :remote_cache
set :use_sudo, false

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

after "deploy:setup", "deploy:setup_shared_dirs"
after "deploy:update_code", "deploy:update_shared_dirs"

namespace :deploy do
  # If you are using Passenger mod_rails uncomment this:
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Set up the shared page_assets folder on the app and web servers" 
  task :setup_shared_dirs, :roles => [:app, :web] do 
    run "mkdir -p -m 775 #{shared_path}/config"
    run "mkdir -p -m 775 #{shared_path}/geo-csv"
    run "mkdir -p -m 775 #{shared_path}/isp"
  end

#  task :update_shared_dirs, :except => { :no_release => true } do 
  task :update_shared_dirs, :roles => [:app, :web] do 
    run "ln -nfs #{shared_path}/log #{latest_release}/log"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/passwords.yml #{release_path}/config/passwords.yml"
    run "ln -nfs #{shared_path}/geo-csv #{release_path}/db/geo-csv"
    run "ln -nfs #{shared_path}/isp #{release_path}/db/isp"
    run "(echo #{Time.now} > #{release_path}/DATE)"
  end
end

