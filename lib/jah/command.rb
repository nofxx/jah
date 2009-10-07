module Jah

  module Command
    COMM = []

    def self.included(base)
      base.extend ClassMethods
    end

    def self.find(msg)
      COMM.select { |r| r[1] =~ msg.squeeze(" ").strip }.first
    end

    module ClassMethods

      def method_missing(*meth)
        read
        @res[meth[0].to_sym]
      end

      def register(handler, regex)
        COMM << [handler, /^#{regex}/, self]
      end

    end

  end
end
