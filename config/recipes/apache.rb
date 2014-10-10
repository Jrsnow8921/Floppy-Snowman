namespace :apache do
  desc "Setup apache configuration for this application"
  task :setup, :roles => :web do
    template "site.erb", "/tmp/apache"
    run "#{sudo} mv /tmp/apache /etc/apache2/sites-enabled/#{application}"
    run "#{sudo} rm -f /etc/apache2/sites-enabled/default"
    restart
  end
  after "deploy:setup", "apache:setup"

  %w[start stop restart].each do |command|
    desc "#{command} apache"
    task command, :roles => :web do
      run "#{sudo} /etc/init.d/apache2 #{command}"
    end
  end
end
