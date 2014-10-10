namespace :log_rotate do
  desc "Setup log rotation for this application"
  task :setup, :roles => :web do
    template "log_rotate.erb", "/tmp/#{application}_rotate"
    run "#{sudo} mv /tmp/#{application}_rotate /etc/logrotate.d/#{application}"
  end
  after "deploy:setup", "log_rotate:setup"
end
