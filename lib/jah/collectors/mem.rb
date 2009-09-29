module Jah

  class Mem < Collector
    attr_reader :total, :free, :used, :percent, :cached, :buffered,
    :swap_total, :swap_free, :swap_used, :swap_percent

    EXEC = "cat /proc/meminfo"

    def self.get
      new
    end

    def initialize
      do_something
    end

    def do_something
      mem_info = {}
      `#{EXEC}`.each do |line|
        _, key, value = *line.match(/^(\w+):\s+(\d+)\s/)
        mem_info[key] = value.to_i
      end
        
      # memory info is empty - operating system may not support it (why doesn't an exception get raised earlier on mac osx?)
      raise "No such file or directory" if mem_info.empty?

      @total = mem_info['MemTotal'] / 1024
      @free = (mem_info['MemFree'] + mem_info['Buffers'] + mem_info['Cached']) / 1024
      @used = @total - @free
      @percent = (@used / @total.to_f * 100).to_i

      @swap_total = mem_info['SwapTotal'] / 1024
      @swap_free = mem_info['SwapFree'] / 1024
      @swap_used = swap_total - swap_free
      unless @swap_total == 0
        @swap_percent = (@swap_used / @swap_total.to_f * 100).to_i
      end
    rescue Exception => e
      if e.message =~ /No such file or directory/
        puts "/proc/meminfo not found.. trying top!"
        top = `top -l 1`.to_a[5].split.map!{|m| m[0..-2].to_i}.reject(&:zero?)
        @used, @free = top[3,4]
        @total = @used + @free
        @percent = (@used / @total.to_f * 100).to_i
      else
        raise e
      end
    end

  end
end
