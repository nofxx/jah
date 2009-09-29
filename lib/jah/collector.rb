module Jah

  class Collector


    def self.quick_results
      "CPU #{Cpu.get.load}, MEM #{Mem.get.percent}%"
    end


  end
end
