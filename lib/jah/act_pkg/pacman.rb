
module Jah

  class Pacman < ActPkg::Base
    BIN = "pacman"

    def all(search = nil)
      run("#{BIN} -Q").to_a.map do |line|
        Pkg.new(:installed, *line.split(" "))
      end
    end

    def install(pkg)
      run "#{BIN} -S #{pkg.name}"
    end

    def uninstall(pkg)
      run "#{BIN} -R #{pkg.name}"
    end

    def info(pkg)
      run "#{BIN} -Qi #{pkg.name}"
    end


    def upgrade
      "-U"
    end

    def update
      "-Syu"
    end

  end

end
