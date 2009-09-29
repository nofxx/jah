module Jah
  class Net < Collector
    #   :net  =>  "netstat -n | grep -i established | wc -l"
    class << self
    #  attr_reader :count, :ips


      def count
        `netstat -n | grep -i established | wc -l`.to_i
      end

      def connections
        `netstat -ntu | grep ESTAB | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr`.to_a.map do |l|
          count, ip = l.split
          [ip, count]
        end
      end
    end







  end
end
