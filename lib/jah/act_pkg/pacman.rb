
module Jah

  class Pacman < ActPkg::Base

    # -Q installed packages
    def all(filter = nil)
      res = run("pacman -Q").to_a.map do |line|
        Pkg.new(:installed, *line.split(" "))
      end
      res.select { |p| p.name =~ /#{filter}/ } if filter
      res
    end

    # -Ss /regex/ search all pkgs
    def search(filter = nil)
      pkgs = []
      installed = all(filter) # until figure out a memoize for all this
      run("pacman -Ss #{filter}").to_a.each_slice(2) do |info, desc|
        name, version, size = info.split("/")[1].split(" ")
        state = installed.find { |i| i.name == name }
        pkgs << Pkg.new(state ? :installed : :new, name, version, desc.strip)
      end
      pkgs
    end

    # -Qi info about a pkg (only installed ones)
    def info(pkg)
      ary = run("pacman -Qi #{pkg.name}").to_a
      return nil if ary[0] =~ /error/
      ary.map! do |i|
        val = i.split("\s:\s")[1]
        val.strip if val
      end #.reject(&:nil?)
      { :url => ary[2], :license => ary[3], :groups => ary[4], :provides => ary[5],
      :depends => ary[6], :required => ary[8], :size => ary[12], :arch => ary[14],
      :desc => ary[19]}
    end

    def install(pkgs)
      pkgs = [pkgs] unless pkgs.class == Array
      run "pacman -Sy --noconfirm #{pkgs.map(&:name).join(' ')}"
    end

    def uninstall(pkg)
      run "pacman -R --noconfirm #{pkg.name}"
    end

    def upgrade(pkg)
      run "pacman -U --noconfirm #{pkg.name}"
    end

    def update
      run "pacman -Syu"
    end

  end

end
