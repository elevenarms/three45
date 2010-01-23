# Please install the Engine Yard Capistrano gem
# gem install eycap --source http://gems.engineyard.com

require "eycap/recipes"

# =============================================================================
# ENGINE YARD REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The :deploy_to variable must be the root of the application.

set :keep_releases,       5
set :application,         "three45"
set :repository,          "svn+ssh://ey@67.207.139.58/usr/local/svn/repos/trunk/webapp/"
set :scm_username,       "ey"
set :scm_password,       "Ey3%15"
set :user,                "three45"
set :password,            "Mu5kien5"
set :deploy_to,           "/data/#{application}"
set :deploy_via,          :filtered_remote_cache
set :repository_cache,    "/var/cache/engineyard/#{application}"
set :monit_group,         "three45"
set :scm,                 :subversion

set :production_database, "three45_production"
set :production_dbhost,   "mysql50-2-master"

set :staging_database, "three45_staging"
set :staging_dbhost,   "mysql50-staging-1"

set :dbuser,        "three45_db"
set :dbpass,        "Aew2fa2E"

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.
  
task :production do
  
  role :web, "74.201.254.36:8100" # three45 [mongrel] [mysql50-2-master]
  role :app, "74.201.254.36:8100", :mongrel => true
  role :db , "74.201.254.36:8100", :primary => true
  
  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

  
task :staging do
  
  role :web, "74.201.254.36:8140" # three45 [mongrel] [mysql50-staging-1]
  role :app, "74.201.254.36:8140", :mongrel => true
  role :db , "74.201.254.36:8140", :primary => true
  
  set :rails_env, "staging"
  set :environment_database, defer { staging_database }
  set :environment_dbhost, defer { staging_dbhost }

end


# =============================================================================
# Any custom after tasks can go here.
# after "deploy:symlink_configs", "three45_custom"
# task :three45_custom, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
#   run <<-CMD
#   CMD
# end
# =============================================================================
task :after_update_code, :roles => :app do
	  run <<-EOF
	    cd #{release_path} && ln -s #{shared_path}/files #{release_path}/public/files
	  EOF
	  run <<-EOF
	    cd #{release_path} && ln -s #{shared_path}/faxes #{release_path}/public/faxes
	  EOF
	  run <<-EOF
	    cd #{release_path} && ln -s #{shared_path}/profile_images #{release_path}/public/profile_images
	  EOF
	  run <<-EOF
	    cd #{release_path} && ln -s #{shared_path}/ads #{release_path}/public/ads
	  EOF
 	  run <<-EOF
 	    cd #{release_path} && ln -s #{shared_path}/sponsors #{release_path}/public/sponsors
 	  EOF
 	  run <<-EOF
 	    cd #{release_path} && ln -s #{shared_path}/tag_sponsors #{release_path}/public/tag_sponsors
 	  EOF
 	  run <<-EOF
 	    cd #{release_path} && ln -s #{shared_path}/tag_logos #{release_path}/public/tag_logos
 	  EOF
 	end
# Do not change below unless you know what you are doing!

after "deploy", "deploy:cleanup"
after "deploy:migrations" , "deploy:cleanup"
after "deploy:update_code", "deploy:symlink_configs"

# uncomment the following to have a database backup done before every migration
# before "deploy:migrate", "db:dump"