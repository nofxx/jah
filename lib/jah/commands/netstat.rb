module Jah
  class Netstat
    include Command
    register(:net, 'net\??$')

    class << self

      def net
        out = ""
        connections.each do |c|
          out << "#{c[0]} => #{c[1]} connections\n"
        end
        out << "Total: #{Net.count}"
      end

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
