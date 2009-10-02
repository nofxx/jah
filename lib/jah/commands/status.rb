module Jah

  class Status
    include Command
    register(:ok, 'ok\??$')
    register(:who, 'who\??$')
    register(:mem, 'mem\??$')
    register(:cpu, 'cpu\??$')
    register(:net, 'net\??$')
    register(:disk, 'disk\??$')
    register(:proks, 'prok$|top$')


    class << self

      def ok
        I18n.t("states." + case Jah::Cpu.med
          when 0..0.5 then :green
          when 0.51..0.7 then :yellow
          else :red
        end.to_s)
      end

      def mem
        Mem.percent.to_s + "%"
      end

      def cpu
        Cpu.load
      end

      def net
        out = ""
        Net.connections.each do |c|
          out << "#{c[0]} => #{c[1]} connections\n"
        end
        out << "Total: #{Net.count}"
      end

      def disk
        Disk.all.map do |d|
          "\n*#{d[:path]}* => #{d[:percent]}"
        end.join("\n")
      end

      def who
        Who.all.map do |w|
          "#{w[:who]} Logado via #{w[:terminal]} desde a data: #{w[:date]}"
        end.join("\n")
      end

      def proks(find = nil)
        Ps.all.map do |p|
          next if find && p.comm !~ /#{find}/i
          "#{p.comm} => #{p.mem}\n"
        end
      end

    end
  end
end
