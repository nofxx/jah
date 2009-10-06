autoload :Pacman, "jah/act_pkg/pacman"

module Jah

  module ActPkg

    def self.get_mine
      const_get(detect.to_s.capitalize).new
    end

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


  end

end
