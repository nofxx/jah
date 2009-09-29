module Jah
  REG = []

  module Command

    def self.included(base)
      base.extend ClassMethods
    end

    def self.find(msg)
      REG.select { |r| r[1] =~ msg.squeeze(" ").strip }.first
    end

    module ClassMethods

    def register(handler, regex)
      REG << [handler, /^#{regex}/, self]
    end

    end

  end
end
