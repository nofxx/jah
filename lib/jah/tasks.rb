Capistrano::Configuration.instance(:must_exist).load do
  abort("Run with jah") unless Object.const_defined?("PROFILES")

  # Load all profiles
  PROFILES.each { |prof| load File.join(".", prof, "deploy.rb")  }

  # Roles
  #   role :web, "fireho.com"
  #   role :db,  "fireho.com", :primary => true
  role :app, HOST["app"]

  # SSH Config
  # ssh_options[:verbose] = :debug
  ssh_options[:port] = HOST["port"] if HOST["port"]

  namespace :setup do

    desc "Setups key on remote"
    task :key do
      key = ENV['key'] || "~/.ssh/id_rsa.pub"
      `ssh-copy-id -i #{key} #{app}`
    end

    desc "Setups a new machine"
    task :cold do
      [:scripts, :pkgs, :gems, :npms].each do |i|
        next if (stuff = WORK[i]).empty?
        send "#{i}_worker", stuff
      end
    end

    desc "Updates all"
    task :up do
      run update_command
      run gems_update if capture("which gem") rescue nil
      run npms_update if capture("which npm") rescue nil
    end

    desc "Updates setups"
    task :files do
      FILES.each do |stack, files|
        up_files stack, files
      end
    end

  end

  # Tail
  #
  namespace :tail do
    desc "Tail Sys"
    task :sys do
      patt = real_args[2] #|| "*"
      stream "sudo tail -f /var/log/#{patt}*.log"
    end
  end

  #
  #
  # CODE
  #
  def get_stack_path(stack, *args)
    File.join(".", stack, *(args.flatten.map(&:to_s)))
  end

  def up_files(stack, files)
    files.each do |file, params|
      fullpath = get_stack_path(stack, :files, file)
      puts "UP #{fullpath} -> #{params}"
      dests = params[:dest]
      dests = [dests] unless dests.is_a? Array
      upload(fullpath, ".", :via => :scp) #do |channel, name, sent, total|
      dests.each do |dest|
        run "sudo mv #{file} #{dest}"
        run "sudo chmod #{params[:perm] || 644} #{dest}"
        run "sudo chown #{params[:user] || 'root:root'} #{dest}"
      end
      #  p sent
      #  p total
      # ...
      #  end
      #upload file, dest
    end
  end

  def read_command pkgs=nil
    line = pkgs.join(' ')
    case HOST["distro"].to_sym
    when :arch, :archlinux then "yaourt --noconfirm -S #{line}"
    when :debian, :ubuntu then "apt-get install --noconfirm --needed #{line}"
    when :osx, :mac then "brew install --noconfirm --needed #{line}"
    when :rhel then "up2date install --noconfirm --needed #{line}"
    else
      abort "FAIL!"
    end
  end


  def install_command pkgs=nil
    line = pkgs.keys.join(' ')
    case HOST["distro"].to_sym
    when :arch, :archlinux then "yaourt --noconfirm -S #{line}"
    when :debian, :ubuntu then "apt-get install --noconfirm --needed #{line}"
    when :osx, :mac then "brew install --noconfirm --needed #{line}"
    when :rhel then "up2date install --noconfirm --needed #{line}"
    else
      abort "FAIL!"
    end
  end

  def update_command pkgs=nil
    line = pkgs ? pkgs.join(' ') : nil
    case HOST["distro"].to_sym
    when :arch, :archlinux then "yaourt -S#{pkgs ? 'y ' + line : 'yu'} --noconfirm"
    when :debian, :ubuntu then "apt-get update #{line}"
    when :osx, :mac then "brew update #{line}"
    when :rhel then "up2date update #{line}"
    else
      abort "FAIL!"
    end
  end

  def real_args
    @@real_args ||= ARGV.select { |a| a !~ /^-/ }
  end

  def scripts_worker scripts
    scripts.each do |script|
      puts "Running script #{script}"
      data = File.open get_stack_path(:scripts, script)
      run data.lines.to_a.join(" && ")
    end
  end

  def pkgs_worker pkgs
    run "sudo #{install_command(pkgs)}"
  end

  def gems_worker gems
    run "sudo gem install #{gems.keys.join(' ')}"
  end

  def gems_update gems=nil
    "sudo gem update #{gems}"
  end

  def npms_update npms=nil
    "sudo gem update #{npms}"
  end

  def npms_worker npms
    run "sudo npm install #{npms.keys.join(' ')}"
  end
end
