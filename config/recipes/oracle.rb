set_default(:oracle_host, "172.16.0.4")
set_default(:oracle_user) { Capistrano::CLI.password_prompt "Oracle User: " }
set_default(:oracle_password) { Capistrano::CLI.password_prompt "Oracle Password: " }
set_default(:oracle_database) { Capistrano::CLI.password_prompt "Oracle Database: " }

namespace :oracle do
  desc "Generate the database.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "oracle.yml.erb", "#{shared_path}/config/database.yml"
  end
  after "deploy:setup", "oracle:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  before "deploy:assets:precompile", "oracle:symlink"
end
