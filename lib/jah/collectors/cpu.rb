module Jah
  class Cpu < Collector
    attr_reader :load, :one, :five, :ten, :med
    EXEC = "uptime"

    def self.get
      new
    end

    def initialize
      l = cpu_load
      @one = l[:one]
      @five = l[:five]
      @ten = l[:ten]
      @load = l.values.join(", ")
      @med = @ten / cores
    end

    def cpu_load
      if `#{EXEC}` =~ /load average(s*): ([\d.]+)(,*) ([\d.]+)(,*) ([\d.]+)\Z/
        { :one    => $2.to_f,
          :five   => $4.to_f,
          :ten    => $6.to_f }
      end
    end

    def cores
      case RUBY_PLATFORM
      when /linux/  then `cat /proc/cpuinfo | grep 'model name' | wc -l`.to_i
      when /darwin/ then `hwprefs cpu_count`.to_i
      else 1
      end
    end
  end
end
