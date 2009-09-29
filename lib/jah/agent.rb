require 'socket'
require 'net/https'
require 'net/http'
require 'zlib'
require 'stringio'
# require 'eventmachine'

module Jah
  class Agent
    PID_FILE = File.join("/tmp", "jah.pid")
    autoload :XmppAgent, "jah/agents/xmpp"
    autoload :PostAgent, "jah/agents/xmpp"
    autoload :DumpAgent, "jah/agents/xmpp"

    def initialize(options=nil)#, config)
      if Jah.daemon?
        puts "Jah starting in background.."
        fork do
          daemonize
          run_agent_run
        end
        exit
      end
      run_agent_run
    end

    def pid_file
      @pidfile ||= PID_FILE
    end

    def run_agent_run
      case Jah.mode # @mode
      when "xmpp" then  XmppAgent.new.run
      when "post" then  PostAgent.new.run
      else
        DumpAgent.new
      end
    end

    def self.start
      new
    end

    def self.stop
      if File.exists?(PID_FILE)
        pid = File.read(PID_FILE)
        puts "Stopping #{pid}"
        `kill #{pid}`
      else
        puts "Jah not running..."
        exit
      end
    end

    def self.restart
      stop
      start
    end

    def daemonize
      begin
        File.open(pid_file, File::CREAT|File::EXCL|File::WRONLY) do |pid|
          pid.puts $$
        end
        at_exit do
          begin
            File.unlink(pid_file)
          rescue
            Log.error "Unable to unlink pid file: #{$!.message}"
          end
        end
      rescue
        pid = File.read(pid_file).strip.to_i rescue "unknown"
        running = true
        begin
          Process.kill(0, pid)
          if stat = File.stat(pid_file)
            if mtime = stat.mtime
              if Time.now - mtime > 25 * 60 # assume process is hung after 25m
                Log.info "Trying to KILL an old process..."
                Process.kill("KILL", pid)
                running = false
              end
            end
          end
        rescue Errno::ESRCH
          running = false
        rescue
          # do nothing, we didn't have permission to check the running process
        end
        if running
          if pid == "unknown"
            Log.warn "Could not create or read PID file. " +
                     "You may need to the path to the config directory. " +
                     "See: http://scoutapp.com/help#data_file"
          else
            Log.warn "Process #{pid} was already running"
          end
          exit
        else
          Log.info "Stale PID file found. Clearing it and reloading..."
          File.unlink(pid_file) rescue nil
          retry
        end
      end

      self
    end
  end


    # def do_something!
    #   if @mode == :online
    #     puts "online"
    #     post(@config[:server], nil, format_out)
    #   else
    #     puts "Writing log.."
    #     f = open("/tmp/jah.txt", "a")
    #     f.write(format_out)
    #     f.close
    #   end
    # end

end
