set :application, "twitter_echo"
set :repository,  Dir.pwd
set :deploy_via, :copy
set :user, "norman"
set :deploy_to, "/apps/#{application}"

set :scm, :git

role :app, "cwninja.com"
role :web, "cwninja.com"
role :db,  "cwninja.com", :primary => true

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
    sudo "god restart twitter_echo"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Link config files from server side shared path."
  task :link_site_config do
    run "for F in #{shared_path}/config/*; do ln -sf $F #{release_path}/config/; done"
  end

  desc "Link database folder for sqlite3."
  task :link_database_dir do
    run "mkdir -p #{shared_path}/sqlite3 && ln -sf #{shared_path}/sqlite3 #{release_path}/db/sqlite3"
  end


  task :install_gems do
    run "cd #{current_path} && sudo rake gems:install"
  end
end

after "deploy:update_code" do
  deploy.link_site_config
  deploy.link_database_dir
end

after "deploy:setup" do
  sudo "chown -R #{user} #{deploy_to}"
end

before "deploy" do
  run "gem query -i -v 2.3.2 -n rails || sudo gem install -v=2.3.2 rails"
  run "gem query -i -n oauth || sudo gem install oauth"
  run "gem query -i -n moomerman-twitter_oauth || sudo gem install moomerman-twitter_oauth -s http://gems.github.com/"
  run "gem query -i -n daemons || sudo gem install daemons"
end

after "deploy:cold" do
  deploy.install_gems
end
