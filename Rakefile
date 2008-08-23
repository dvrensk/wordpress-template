
task :default do
  FileUtils.mkdir_p "build"
  system "git archive --format=zip --prefix=projektnamn/ HEAD:projektnamn/ > build/nytt_wp_projekt.zip"
end

task :clean do
  FileUtils.rm_rf "build"
  FileUtils.rm_f ["projektnamn/config/wp-config.php", "projektnamn/wordpress/wp-config.php"]
end

task :test => [:clean] do
  FileUtils.mkdir_p "build"
  system "git archive --format=tar --prefix=projektnamn/ HEAD:projektnamn/ | (cd build; tar xf -)"
end
