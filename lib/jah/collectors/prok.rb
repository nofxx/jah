module Jah

  class Ps < Collector
    COMM = "ps auxww"

    def self.all
      `#{COMM}`.to_a[1..-1].map do |l|
          Prok.new(l.split)
        end
    end

    def self.find(name)

    end


  end

  class Prok
    BANLIST = [/^ata/, /^init$/, /^scsi_/, /\/\d$/, /agetty/ ]
    attr_reader :pid, :comm, :cpu, :mem, :rss, :vsz, :stat

    def initialize(args) #      USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
      return unless args[0]
      @user  = args[0]
      @pid   = args[1].chomp.to_i
      @cpu   = args[2].chomp.to_f
      @mem   = args[3].chomp.to_f
      @vsz   = args[4].chomp.to_i
      @rss   = args[5].chomp.to_i
      @tty   = args[6]
      @stat  = args[7]
      @start = args[8]
      @time  = args[9]
      @comm  = args[10]
      #@shr  = args[6]
    end

    def hup!
      exec "kill -1 #{pid}"
    end

    def kill!
      exec "kill #{pid}"
    end

    def move_to_acre!
      exec "kill -9 #{pid}"
    end

    def self.genocide!(ary, f = nil)
      for prok in ary
        prok.kill
      end
    end

    def exec(comm)
      # SSHWorker.new(@host, @host.user, comm)
    end

    def force(f)
      { :hup => "-1", :die => "-9"}[f]
    end
  end

end

    # COMM = {
    #   :top => "top -n 1",
    # }



  #  def top
  #   info, tasks, cpus, mem, swap, n, n, *rest = *@res[:top]
  #   n, total, used, free, buffered = *mem.match(/(\d*)k\D*(\d*)k\D*(\d*)k\D*(\d*)k.*/)
  #   cached = swap.match(/(\d*)k cached/)[0]
  #   proks = rest.map do |r|
  #     r.split(" ")
  #   end

  #   # fail... top don't show a good stat....
    #   @proks = proks.reject do |p|
    #     p[0] == nil || Prok::BANLIST.select{ |pl| pl =~ p[11] }[0]
    #   end
    #    rescue => e
    #    nil
    # end
