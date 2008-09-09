set :application, "vad-projektet-heter"
set :host, "www.projektnamn.se"
set :user, "användarnamn"
set :repository,  "git@martiniq.vrensk.com:repos/informo/#{application}.git"
# fs-data :-)
set :home, "/home/#{user[0,1]}/#{user}"

# set :scm_command, "#{home}/bin/git"

# Inget att ändra efter den här raden.

set :scm, "git"
set :local_scm_command, :default
set :scm_verbose, true # eftersom git-reset inte tar -q i den här versionen...
set :branch, "master"
set :deploy_via, :remote_cache
set :deploy_to, "#{home}/#{application}"
set :keep_releases, 3

role :app, "#{user}@#{host}"
set :use_sudo, false

namespace :deploy do
  desc "Deploys your project. The same as 'update'"
  task :default do
    update
  end
  desc <<-DESC
    [internal] Touches up the released code. This is called by update_code \
    after the basic deploy finishes.

    This task will copy config.php and dot_htaccess from the shared 'system' \
    directory to cw_config and public_html, and then create a symbolic link \
    from public_html/data to 'data' in the shared directory.
  DESC
  task :finalize_update, :except => { :no_release => true } do
    run <<-CMD
      rm -rf #{latest_release}/wordpress/wp-config.php \
      #{latest_release}/wordpress/.htaccess \
      #{latest_release}/wordpress/wp-content/uploads \
      #{latest_release}/.git &&
      ln -s #{shared_path}/uploads #{latest_release}/wordpress/wp-content &&
      chmod -R u-w #{latest_release}/wordpress/wp-content/themes
    CMD

    # Prefer files from the repo but use files in system/ otherwise
    [%w(wp-config.php wp-config.php), %w(dot_htaccess .htaccess)].each do |(source, target)|
      if File.exists?(File.join(File.dirname(__FILE__), source))
        dir = "#{latest_release}/config"
      else
        dir = "#{shared_path}/system"
      end
      run "cp #{dir}/#{source} #{latest_release}/wordpress/#{target}"
    end

    if fetch(:normalize_asset_timestamps, true)
      stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
      run "find #{latest_release}/wordpress/wp-content/themes -exec touch -t #{stamp} {} ';'; true", :env => { "TZ" => "UTC" }
    end
  end

  desc "Do nothing.  Overrides Rails' standard."
  task :restart, :roles => :app do
  end
  desc "Do nothing.  Overrides Rails' standard."
  task :migrate, :only => { :primary => true } do
  end
  task :warn_about_known_hosts do
    puts <<-WARNING
      >>>
      >>> Your next step is to 'deploy' which fetches the source from the repository.
      >>> If you have problem fetching the source code, ensure that your repository
      >>> server is in the servers' list of known hosts.
      >>>
    WARNING
  end
  after 'deploy:setup', 'deploy:warn_about_known_hosts'
end

namespace :wordpress do
  task :setup do
    run "touch #{shared_path}/system/dot_htaccess"
    run "mkdir -m 777 -p #{shared_path}/uploads"
    wp_config = File.join(File.dirname(__FILE__), '../wordpress/wp-config-sample.php')
    upload(wp_config, "#{shared_path}/system/", :via => :scp)
  end
end
after 'deploy:setup', 'wordpress:setup'
