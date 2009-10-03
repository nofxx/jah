module Jah

  class Status
    include Command
    register(:ok, 'ok\??$')


    class << self

      def ok
        I18n.t("states." + case Jah::Cpu.med
          when 0..0.5 then :green
          when 0.51..0.7 then :yellow
          else :red
        end.to_s)
      end


    end
  end
end
