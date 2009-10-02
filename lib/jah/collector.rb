module Jah

  class Collector


    def self.quick_results
      "CPU #{Cpu.get.load}, MEM #{Mem.get.percent}%"
    end


    def self.method_missing(*meth)
      read
      @res[meth[0].to_sym]
    end


  end
end
