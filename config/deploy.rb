require "bundler/capistrano"
require 'net/https'
require 'json'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "pencilbox_production"
set :repository,  "git@github.com:michiels/pencilbox.git"
set :deploy_via, :checkout

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
  run "rm -f #{release_path}/config/initializers/secret_token.rb; ln -nfs #{shared_path}/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
end

before "deploy:update_code", "semaphore:check"
before "deploy:finalize_update", "deploy:generate_secret"

namespace :semaphore do
  task :check do
    commit_sha = real_revision

    if File.exists?(File.expand_path("~/bin/hub"))
      `~/bin/hub ci-status #{commit_sha}`
      build_success = $?.success?
    else
      uri = URI.parse("https://api.github.com/repos/michiels/pencilbox/statuses/#{commit_sha}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      response = http.get(uri.request_uri)

      commit_status = JSON.parse(response.body)
      build_success = commit_status.first['state'] == "success"
    end

    if !build_success
      raise CommandError.new("The commit that is being deployed does not have a succesful build status.")
    end
  end
end

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

namespace :deploy do
  task :generate_secret do
    if !remote_file_exists?("#{shared_path}/config/initializers/secret_token.rb")
      secret = `rake secret`
      secret_stuff = <<-EOF
Pencilbox::Application.config.secret_key_base = '#{secret}'
      EOF

      put secret_stuff, "#{shared_path}/config/initializers/secret_token.rb"
    end
  end

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