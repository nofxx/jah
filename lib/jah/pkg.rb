#
# ActPkg - Say 'install' and it works =D
#
# Nice tables:
# http://distrowatch.com/dwres.php?resource=package-management
# http://www.guiadohardware.net/dicas/referencia-pacotes-linux.html
#
module Jah

   class Pkg
    include Comparable
    attr_reader :name, :version, :status, :size

    def initialize(*args)
      @status, @name, @version, @desc = args
    end

    def desc
      @desc ||= info[:desc]
    end

    def info
      @info ||= ActPkg.info(self)
    end

    def installed?
      @status == :installed
    end

    def install
      ActPkg.install(self)
    end

    def uninstall
    end

    def ==(other)
      (name == other.name) && (version == other.version)
    end

    def <=>(other)
      raise "Not same pkg.." unless name == other.name
      version <=> other.version
    end

    def valid?
      !(@name.nil? or @version.nil?)
    end


    def method_missing(*meth)
      unless (val = info[meth[0]]).nil?
        val
      else
        raise NoMethodError
      end
    end
  end

end
