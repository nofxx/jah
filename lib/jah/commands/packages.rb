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
        case res = ActPkg.send(*meths)
        when Array
          res.map { |i| ">#{i.name}  #{i.version}\n" }
        when String then res
        end
      end
    end

  end
end
