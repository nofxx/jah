module Jah

  class Prok
    include Command
    attr_reader :user, :pid, :comm, :cpu, :mem, :rss, :vsz, :stat, :tty, :time
    BANLIST = [/^ata/, /^init$/, /^scsi_/, /\/\d$/, /agetty/ ]
    register(:read, 'proks?\s|top$')

    def self.read(find = nil)
      find ? Prok.find(find).to_s : Prok.all.map(&:to_s)

    end

    def self.all
       `ps auxww`.to_a[1..-1].map do |l|
        new(l.split)
      end
    end

    def self.find(comm_or_pid)
      all.select do |p|
        unless comm_or_pid.to_i.zero?
          p.pid == comm_or_pid.to_i
        else
          p.comm =~ /#{comm_or_pid}/
        end
      end
    end

    # USER  PID  %CPU  %MEM  VSZ  RSS  TTY  STAT  START  TIME  COMMAND
    def initialize(args)
      return unless args[0]
      @user, @pid, @cpu, @mem, @vsz, @rss, @tty, @stat, @start, @time, *@comm = args

      @pid, @vsz, @rss = [@pid, @vsz, @rss].map(&:to_i)
      @cpu, @mem = [@cpu, @mem].map(&:to_f)
      @comm = @comm.join(" ")
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

    def to_s
      "#{pid} - #{user} - #{comm} (#{mem}, #{cpu})"
    end

    def self.genocide!(ary)
      parsed = ary.gsub(/\W/, "").split(" ")
      for prok in parsed
        find(prok).each(&:kill!)
      end
    end

    protected

    def exec(comm)
      puts "[PROK] exec => #{comm}"
      `#{comm}`
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
