module Jah

  class Prayer
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

