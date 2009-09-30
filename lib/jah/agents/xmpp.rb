require "eventmachine"#autoload :Client,
require "blather/client/client"

module Jah
 # include Blather::DSL
  class XmppAgent
    ROSTER = []
    attr_reader :client


    def initialize #(jid, key, server, port=5222, debug=false, report=0)
      Blather.logger.level = Logger::DEBUG if Jah.debug
      @report = Jah.report
      @client = Blather::Client.setup Jah.jid, Jah.key, Jah.server, Jah.port
      setup
      self
    end

    def process_message(to, msg, type = :chat)
      args = msg.split(" ")
      if comm = Jah::Command.find(msg)
        puts "Commmand => #{comm} | #{msg}"
        body = comm[2].send(comm[0], *args[1..-1])
      elsif pub = PUBSUB[:pubs].find { |p| msg =~ /^#{p}/ }
        client.write Pub.send("publish", pub, *args[1..-1])
        body = "Publishing...."
      else
        keywords = %w{ start stop restart monitor unmonitor }
        kind = :god if msg =~ /#{keywords.join("|")}/
        kind ||= msg =~ /^\!/ ? :ruby : :sh
        body = case kind
          when :ruby
          puts "Executing ruby command => #{msg}"
          "=> #{execute_ruby(msg)}"
          when :sh
          puts "Executing *sh command => #{msg}"
          "$> #{execute_sh(msg)}"
          when :god
          puts "Executing god command => #{msg}"
          "G> #{execute_sh('god ' + msg)}"
          else "dunno what to do...."
        end
      end
      #beautify(body)
     [ Blather::Stanza::Message.new(to, body, type)]
      rescue => e
      "Something is wrong.. #{e}\n#{e.backtrace.join("\n")}"
    end

    # Naive.... to be improved
    def execute_ruby(code)
      keywords = / class | module | def | do | while | for /
      if code =~ keywords
        return "Unmatched ends" if code.scan(keywords).length != code.scan(/end(\s|$)/).length
      end
      return "Unmatched.." if code.scan(/\{|\(|\[/).length != code.scan(/\}|\)|\]/).length
      return "Unmatched quotes.." if code.scan(/\"|\'/).length % 2 != 0
      begin
        eval(code[1..-1]) || "nil"
      rescue => e
        "Fail => #{e}"
      end
    end

    def execute_sh(code)
      return I18n.t(:no_sudo) if code =~ /sudo/
      res = `#{code}`.chomp
      ex = $?.exitstatus
      if ex != 0
        res << I18n.t(:exit_code, :ex => ex.to_s)
      else
        res = "\n" + res unless res.split("\n").length < 2
      end
      res
    end

    #TODO: need to write raw....
    def beautify(txt)
      #txt.gsub!(/\*(.*)\*/, "<span style=\"font-weight: bold;\">\\1</span>")
      #txt.gsub!(/\/(.*)\//, "<em>\\1</em>") # Italic
      #txt.gsub!(/\_(.*)\_/, "<span style=\"font-decoration: underline;\">\\1</span>")
      #txt.gsub!(/\-(.*)\-/, "<span style=\"font-decoration: line-through;\">\\1</span>")
      #   <span style="font-size: large;">ok?</span>
      #   <span style="color: #FF0000;">ok?</span>
      txt
    end

    # [:iq, :query, :roster, :disco_info, :disco_items, :message, :presence,
    #  :status, :subscription, :pubsub_node, :pubsub_affiliations,
    #  :pubsub_create, :pubsub_event, :pubsub_items, :pubsub_publish,
    #  :pubsub_retract, :pubsub_subscribe, :pubsub_subscription,
    #  :pubsub_subscriptions, :pubsub_unsubscribe, :pubsub_owner,
    #  :pubsub_delete, :pubsub_purge]


    def setup
      #  return if client && client.setup?
      client.register_handler(:ready) do
        puts "Connected!"
        ROSTER << [client.roster.items.keys, Jah.groups].flatten.uniq
        ROSTER.flatten!
        ROSTER.select { |j| j =~ /\@conference\./ }.each do |c|
          presence = Blather::Stanza::Presence.new
          presence.to = "#{c}/#{Jah.hostname}"
          client.write presence
        end

        client.write Blather::Stanza::PubSub::Affiliations.new(:get, "pubsub.fireho.com")
        client.write Blather::Stanza::PubSub::Subscriptions.new(:get, "pubsub.fireho.com")
      end

      client.register_handler :subscription, :request? do |s|
        if ROSTER.include?(s.from.stripped.to_s)
          puts "[REQUEST] Approve #{s}"
          client.write s.approve!
        else
          puts "[REQUEST] Refuse #{s}"
          client.write s.refuse!
        end
      end

      # client.register_handler :message, :chat?, :body => 'exit' do |m|
      #   client.write Blather::Stanza::Message.new(m.from, 'Exiting...')
      #   client.close
      # end
      #client.register_handler :roster, [],
      #client.register_handler :message, :error?, :body do |m|
      #client.register_handler :message, :headline?, :body do |m|
      #client.register_handler :message, :normal?, :body do |m|
      client.register_handler :pubsub_affiliations, :affiliations do |m|
        puts "[PUB] =>  #{m.inspect}"
        m.each do |af|
          PUBSUB[:pubs] << af[1][0].gsub(/\//, '')
        end
      end

      client.register_handler :pubsub_subscriptions, :subscriptions, :list do |m|
        puts "[SUB] =>  #{m.inspect}"
        m.each do |af|
          PUBSUB[:subs] << af[1][0][:node].gsub(/\//, '')
        end
      end

      client.register_handler :pubsub_event, :items do |m|
        #PUBSUB[:pubs] =
        puts "[PUBSUB] => #{m.inspect}"
        puts m.items
        client.write m.body
      end

      client.register_handler :message, :groupchat? do |m|
        if m.body =~ Regexp.new(Jah.hostname)
          body = m.body.split(":")[-1].strip
        else
          body = m.body
        end
        if m.body =~ /^!|^>|^\\|#{Jah.hostname}/ && m.to_s !~ /x.*:delay/ #delay.nil?
          puts "[GROUP] => #{m.inspect}"
          for msg in process_message(m.from.stripped, body, :groupchat)
            client.write msg
          end
        end
      end

      client.register_handler :message, :chat?, :body do |m|
        if ROSTER.include?(m.from.stripped.to_s)
          puts "[PVT] => #{m.inspect}"
          for msg in process_message(m.from, m.body)
            client.write msg
          end
        end
      end

    end


    def run
      puts "Starting Jah Client...#{client.jid.stripped}"
      trap(:INT) { EM.stop }
      trap(:TERM) { EM.stop }

      EM.run do
        client.run
        if @report != 0
          puts "will report..."
          EM.add_periodic_timer(@report) do
            puts " I'm ok.. "
            client.write Blather::Stanza::Message.new(
                "nofxx@Jah.host.com", Jah::Collector.quick_results)
          end
        end

      end


    end

  end

end


# # when_ready do
# #   roster.grouped.each do |group, items|
# #     puts "#{'*'*3} #{group || 'Ungrouped'} #{'*'*3}"
# #     items.each { |item| puts "- #{item.name} (#{item.jid})" }
# #     puts
# #   end
# #   shutdown
# # end

# # message :chat?, :body do |m|
# #   begin
# #     say m.from, eval(m.body)
# #   rescue => e
# #     say m.from, e.inspect
# #   end


#   end
