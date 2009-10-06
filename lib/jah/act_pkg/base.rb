module Jah
  module ActPkg

    class Base


      def install(comm = "install")
        BIN + comm
      end

      def run(comm)
        `#{comm}`
      end

    end
  end
end
