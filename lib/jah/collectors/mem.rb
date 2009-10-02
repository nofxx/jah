module Jah

  class Mem < Collector

    class << self
      def read
        mem_info = {}
        `cat /proc/meminfo`.each do |line|
          _, key, value = *line.match(/^(\w+):\s+(\d+)\s/)
          mem_info[key] = value.to_i
        end

        # memory info is empty - operating system may not support it (why doesn't an exception get raised earlier on mac osx?)
        raise "No such file or directory" if mem_info.empty?
        @res = {}
        @res[:total] = total = mem_info['MemTotal'] / 1024
        @res[:free] = free = (mem_info['MemFree'] + mem_info['Buffers'] + mem_info['Cached']) / 1024
        @res[:used] = total - free
        @res[:percent] = (free / total.to_f * 100).to_i

        @res[:swap_total] = stotal = mem_info['SwapTotal'] / 1024
        @res[:swap_free] = sfree = mem_info['SwapFree'] / 1024
        # @res[:swap_used] = stotal - sfree
        # unless stotal == 0
        #   @swap_percent = (@swap_used / @swap_total.to_f * 100).to_i
        # end
      rescue Exception => e
        if e.message =~ /No such file or directory/
          puts "/proc/meminfo not found.. trying top!"
          top = `top -l 1`.to_a[5].split.map!{|m| m[0..-2].to_i}.reject(&:zero?)
          @res[:used], @res[:free] = top[3,4]
          @res[:total] = @res[:used] + @res[:free]
          @res[:percent] = (@res[:free] / @res[:total].to_f * 100).to_i
        else
          raise e
        end
      end

    end
  end
end
