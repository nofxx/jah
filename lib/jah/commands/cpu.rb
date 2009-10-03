module Jah
  class Cpu
    include Command
    register(:load, 'cpu\??$')

    class << self

      def load
        read
        "Med: #{@res[:med]}"
      end

      def read
        @res = cpu_load
        @res[:load] = @res.values.join(", ")
        @res[:med]  = @res[:ten] / @res[:cores] = cores
        @res
      end

      def cpu_load
        if `uptime` =~ /load average(s*): ([\d.]+)(,*) ([\d.]+)(,*) ([\d.]+)\Z/
          { :one  => $2.to_f,
            :five => $4.to_f,
            :ten  => $6.to_f }
        end
      end

      def cores
        @cores ||= case RUBY_PLATFORM
        when /linux/  then `cat /proc/cpuinfo | grep 'model name' | wc -l`.to_i
        when /darwin/ then `hwprefs cpu_count`.to_i
        else 1
        end
      end

    end
  end
end
