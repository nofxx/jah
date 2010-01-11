require 'logger'

module Jah

  HOME = ENV['HOME'] + "/.jah/"
  unless File.exists? HOME
    FileUtils.mkdir_p HOME
  end

  I18n.default_locale = "en_us"

  Log = Logger.new(HOME + "jah.log")
  def Log.write(d); self.warn(d); end
  # $stderr = Log

  # Opt = {}
  OptBackup = {}

  class Opt
    @hash = {}

    class << self
      def hash
        @hash
      end

      def defaults
        { :mode => "xmpp", :daemon => false, :port => 5222 }
      end

      def hostname
        @hostame ||= `hostname`.chomp.gsub(/\W/, "") rescue "jah#{rand(42000)}"
      end

      def locale
        @locale ||= `locale | grep LANG`.scan(/LANG=(.*)\./)[0][0].downcase rescue "en_us"
      end

      # Load config [., ~/.jah, /etc]
      def autoload_config(options)
        conf = "jah.yaml"
        unless file = options[:config]
          if file = [nil, HOME, "/etc/"].select { |c| File.exists? "#{c}#{conf}" }[0]
            file << conf
            options[:config] = file
          end
        end
        options = YAML.load(File.read(file)).merge!(options) if file rescue nil

        I18n.locale = options[:i18n] if options[:i18n]
        options[:groups] ||= []

        @hash.merge!(defaults )
        @hash.merge!(options)
        OptBackup.merge!(@hash)
      end

      def closing_time!
        if @hash != OptBackup
          puts "Writing config..."
          File.open(@hash[:config], "w+") do |f|
            f.write "# Auto generated on #{Time.now}"
            f.write @hash.to_yaml
          end
        end
      end

      def [](val);           @hash[val];            end
      def []=(key, val);     @hash[key] = val;      end
      def merge!(val);       @hash.merge!(val);     end

      def method_missing(*meth)
        key = meth[0].to_s.gsub(/\?|=/, "").to_sym
        if val = meth[1]
          @hash[key] = val
        elsif !(val = @hash[key]).nil?
          val
        else
          raise "No method #{val} #{key}"
        end
      end

    end

  end

end
