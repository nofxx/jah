module Jah

  class Packages
    include Command
    register(:install, "install\s")
    register(:pkg, "pkg\s")


    class << self

      def install(foo)
        ActPkg.install(foo)
      end

      def pkg(*meths)
        ActPkg.send *meths
      end
    end

  end
end
