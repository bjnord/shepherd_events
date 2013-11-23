# Capistrano settings
require 'bundler/capistrano'
require 'capistrano/ext/multistage'
set :stages, %w(production)
set :default_stage, 'production'

# application settings
set :application, 'shepherd_events'

# SCM settings
set :repository, 'https://github.com/bjnord/shepherd_events.git'
set :scm, :git
set :scm_verbose, true
set :deploy_via, :remote_cache

# other settings
set :use_sudo, false
#set :ssh_options, { forward_agent: true }
set :keep_releases, 12
after 'deploy:update_code', 'deploy:symlink_app_config'
after 'deploy', 'deploy:cleanup'
after 'deploy:migrations', 'deploy:cleanup'

# custom tasks
namespace :deploy do
  desc "Symlinks the app_config.yml"
  task :symlink_app_config, :roles => [:web, :app, :db] do
    run "ln -nfs #{deploy_to}/shared/config/app_config.yml #{release_path}/config/app_config.yml"
  end
end
