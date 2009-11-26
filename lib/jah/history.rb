module Jah

  class History

    @cache = []

    class << self

      def set(jid, body, time = Time.now)
        @cache << [jid, body, time]
      end
      alias :add :set

      def all(filter = nil)
        filter ? @cache.select { |i| i[0] =~ /#{filter}/ } : @cache
      end

      # delegate?
      def method_missing(*meth)
        @cache.send(*meth)
      end

    end
  end
end
