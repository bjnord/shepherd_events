require 'bundler/capistrano'

require 'capistrano/ext/multistage'
set :stages, %w(preproduction)
set :default_stage, 'preproduction'

# application settings
# set :application, 'your_application_name_here'

# SCM settings
# set :repository, 'your_repository_path_here'
set :scm, :git
set :scm_verbose, true
set :deploy_via, :remote_cache

# other settings
set :use_sudo, false
set :ssh_options, { forward_agent: true }
set :keep_releases, 12
after 'deploy', 'deploy:cleanup'
after 'deploy:migrations', 'deploy:cleanup'

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
