module Jah


  class Yum < ActPkg::Base

    def all(filter = nil)
      run("yum -q list installed").to_a[1..-1].map do |l|
        name, version = l.split(" ")[0..1]
        Pkg.new(:installed, name.split(".i")[0], version )
      end
    end
    
    # all pkgs...search repo
    def info(pkg)
      
    end

    def install(what)
      "yum install #{what}"
    end

    def uninstall
      "remove"
    end

    def update
      "check-update"
    end
  end

end
