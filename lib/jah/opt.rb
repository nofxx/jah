require 'logger'

module Jah

  HOME = ENV['HOME'] + "/.jah/"
  unless File.exists? HOME
    FileUtils.mkdir_p HOME
  end

  Log = Logger.new(HOME + "jah.log")
  def Log.write(d); self.warn(d); end
  # $stderr = Log


  Opt = {}
  OptBackup = {}

  def self.hostname
    `hostname`.chomp.gsub(/\W/, "") rescue "jah#{rand(42000)}"
  end

  def self.locale
    `locale | grep LANG`.scan(/LANG=(.*)\./)[0][0].downcase rescue "en_us"
  end

  def method_missing(w)
    Opt[w.to_s.gsub("?", "").to_sym]
  end


end
