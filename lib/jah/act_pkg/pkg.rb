module Jah

  class Pkg
    include Comparable
    attr_reader :name, :version, :status, :desc, :size, :url, :arch

    def initialize(*args)
      @status, @name, @version, @desc = args
    end

    def installed?
      @status == :installed
    end

    def install
      ActPkg.install(name)
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


  end
end
