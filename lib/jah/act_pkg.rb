autoload :Pacman, "jah/act_pkg/pacman"
autoload :Apt, "jah/act_pkg/apt"
autoload :Yum, "jah/act_pkg/yum"

module Jah

  module ActPkg

    def self.detect
      case File.read("/etc/issue")
        when /Arch/i    then :pacman
        when /SUSE/i    then :zypp
        when /Mandriva/ then :urpm
        when /Fedora|CentOS/ then :yum
        when /Debian|Ubuntu/ then :apt
        when /This|Gentoo/   then :portage
        when /Welcome|Slack/ then :slackpkg
        else
        raise "Is this LFS??"
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
