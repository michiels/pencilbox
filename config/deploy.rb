require "bundler/capistrano"
# require "sidekiq/capistrano"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "pencilbox_production"
set :repository,  "git@github.com:michiels/pencilbox.git"
set :deploy_via, :remote_cache

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "thisispencilbox.com"                          # Your HTTP server, Apache/etc
role :app, "thisispencilbox.com"                          # This may be the same as your `Web` server
role :db,  "thisispencilbox.com", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

set :user, "deploy"
set :use_sudo, false

set :branch, ENV['BRANCH'] || "master"

before "deploy:finalize_update" do
  run "rm -f #{release_path}/config/database.yml; ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  #run "rm -f #{release_path}/config/sidekiq.yml; ln -nfs #{shared_path}/config/sidekiq.yml #{release_path}/config/sidekiq.yml"
  run "rm -f #{release_path}/log; ln -nfs #{shared_path}/log #{release_path}/log"
  run "rm -f #{release_path}/config/initializers/dropbox.rb; ln -nfs #{shared_path}/config/initializers/dropbox.rb #{release_path}/config/initializers/dropbox.rb"
  run "mkdir #{release_path}/tmp;"
  run "ln -nfs #{shared_path}/pids #{release_path}/tmp/pids"
  run "ln -nfs #{shared_path}/sockets #{release_path}/tmp/sockets"
  run "ln -nfs #{shared_path}/../config/unicorn.rb #{release_path}/config/unicorn.rb"
end

namespace :deploy do
  task :start do
    run "sudo bluepill load /etc/bluepill/#{application}.pill"
  end
  task :stop do
    run "sudo bluepill #{application} stop"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "sudo bluepill #{application} restart"
  end
  task :status do
    run "sudo bluepill #{application} status"
  end
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
end