# preproduction stage

set :user, 'ec2-user'
server 'yourserverhere.compute.amazonaws.com', :app, :web, :db, :primary => true
set :deploy_to, '/home/ec2-user/shepherd_events'

set :rails_env, 'production'

# Unicorn settings
require 'capistrano-unicorn'
set :unicorn_config_filename, 'unicorn/production.rb'
#after 'deploy:restart', 'unicorn:duplicate' # preload_app + before_fork
# FIXME unicorn:duplicate doesn't seem to pick up our changes
# <http://stackoverflow.com/questions/9388074/restarting-unicorn-with-usr2-doesnt-seem-to-reload-production-rb-settings>
after 'deploy:restart', 'unicorn:restart' # app preloaded
