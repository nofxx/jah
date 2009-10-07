
module Jah

  class Pacman < ActPkg::Base
    BIN = "pacman"

    def all(filter = nil)
      run("#{BIN} -Q #{filter}").to_a.map do |line|
        Pkg.new(:installed, *line.split(" "))
      end
    end

    def search(filter = nil)
      res = run("#{BIN} -Ss #{filter}").to_a
      pkgs = []
      (0..res.length-1).step(2) do |r|
        name, version, size = res[r].split("/")[1].split(" ")
        pkgs << Pkg.new(:new, name, version, res[r+1].strip)
      end
      pkgs
    end

    def install(pkg)
      run "#{BIN} -Sy --noconfirm #{pkg.name}"
    end

    def uninstall(pkg)
      run "#{BIN} -R --noconfirm #{pkg.name}"
    end

    def info(pkg)
      ary = run("#{BIN} -Qi #{pkg.name}").to_a
      ary.map! do |i|
        val = i.split("\s:\s")[1]
        val.strip if val
      end #.reject(&:nil?)
      { :url => ary[2], :license => ary[3], :groups => ary[4], :provides => ary[5],
      :depends => ary[6], :required => ary[8], :size => ary[12], :arch => ary[14],
      :desc => ary[19]}
    end


    def upgrade(pkg)
      run "pacman -U #{pkg.name}"
    end

    def update
      run "pacman -Syu"
    end

  end

end
