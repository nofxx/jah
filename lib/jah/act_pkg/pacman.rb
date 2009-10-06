
module Jah

  class Pacman < ActPkg::Base
    BIN = "pacman"

    def self.all(search = nil)
      "-Q"
    end

    def install(what)
      run "pacman -S #{what}"
    end

    def uninstall
      "-R"
    end

    def upgrade
      "-U"
    end

    def update
      "-Syu"
    end

  end

end
