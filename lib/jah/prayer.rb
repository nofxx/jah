module Jah

  class Prayer

    def initialize(config)
      @config = config
      setup
      ping
    end

    def self.watch(options = {})
      
      God.watch do |w|
        w.name              = "jah"
        w.interval          = 1.minute
        w.start             = "jah #{options[:config]}"
        w.start_grace       = 10.seconds
        w.restart_grace     = 10.seconds

        w.start_if do |start|
          start.condition(:process_running) do |c|
            c.running = false
          end
        end

        w.restart_if do |restart|
          restart.condition(:memory_usage) do |c|
            c.above = 30.megabytes
            c.times = [3, 5]
          end

          restart.condition(:cpu_usage) do |c|
            c.above = 25.percent
            c.times = 5
          end
        end

        w.lifecycle do |on|
          on.condition(:flapping) do |c|
            c.to_state = [:start, :restart]
            c.times = 5
            c.within = 5.minute
            c.transition = :unmonitored
            c.retry_in = 10.minutes
            c.retry_times = 5
            c.retry_within = 2.hours
          end
        end
      end
    end

    def setup
      DRb.start_service
      @server = DRbObject.new(nil, God::Socket.socket(@config['god_port'])) || nil
    rescue => e
      @config[:god] = false
    end

    # ping server to ensure that it is responsive
    def ping
      if god?
        tries = 3
        begin
          @server.ping
        rescue Exception => e
          retry if (tries -= 1) > 1
          raise e, "The server is not available (or you do not have permissions to access it)"
        end
      end
    end


  end
end

