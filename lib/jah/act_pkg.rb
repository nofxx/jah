autoload :Pacman, "jah/act_pkg/pacman"
autoload :Apt, "jah/act_pkg/apt"
autoload :Yum, "jah/act_pkg/yum"

module Jah

  module ActPkg

    def self.detect
      if RUBY_PLATFORM =~ /darwin/
        :ports
      else
        case File.read("/etc/issue")
        when /Arch/i    then :pacman
        when /SUSE/i    then :zypp
        when /Mandriva/ then :urpm
        when /BSD/      then :ports
        when /Fedora|CentOS/ then :yum
        when /Debian|Ubuntu/ then :apt
        when /This|Gentoo/   then :emerge
        when /Welcome|Slack/ then :slack
        else
          raise "Is this LFS??"
        end
      end
    end

    def self.manager
      @manager ||= const_get(detect.to_s.capitalize).new
    end

    def self.method_missing(*meth)
      manager.send(*meth)
    end
  end

end
