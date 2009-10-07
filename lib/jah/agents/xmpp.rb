require "blather/client/client"

module Jah
 # include Blather::DSL
  class XmppAgent
    ROSTER = []
    PUBSUB = {:pubs => [], :subs => []}
    PEERS = []

    attr_reader :client


    def initialize #(jid, key, server, port=5222, debug=false, report=0)
      Blather.logger.level = Logger::DEBUG if Opt.debug
      @report = Opt.report
      @client = Blather::Client.setup Opt.jid, Opt.key, Opt.server, Opt.port
      setup
      self
    end

    def process_message(to, msg, type = :chat)
      args = msg.split(" ")
      if comm = Jah::Command.find(msg)
        puts "Commmand => #{comm} | #{msg}"
        body = comm[2].send(comm[0], *args[1..-1])
      elsif pub = PUBSUB[:pubs].find { |x| msg =~ /^#{x}:/ }
        publish_pub(pub, *args[1..-1])
        body = "Publishing...."
      else
        keywords = %w{ start stop restart monitor unmonitor }
        kind = case msg
               when /#{keywords.join("|")}/ then :god
               when /^\!/ then :ruby
               when /^pub\s/ then :pub
               else :sh
               end
        body = case kind
          when :sh
          puts "Executing *sh command => #{msg}"
          "$> #{execute_sh(msg)}"
          when :pub
          PEERS << to.stripped unless PEERS.find { |p| p == [to.stripped] }
          puts "Executing pubsub command => #{msg}"
          "P> #{execute_pub(msg)}"
          when :ruby
          puts "Executing ruby command => #{msg}"
          "=> #{execute_ruby(msg)}"
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

    def execute_pub(code)
      comm = code.split(" ")
      case comm[1]
      when "all" then all_pubs
      when "mine" then my_pubs
      when "list" then list_pub(comm[2])
      when "fetch" then fetch_pubs || "Done."
      when "create" then create_pub(comm[2])
      when /^sub\w*/  then sub_pub(comm[2])
      when /^unsub\w*/  then unsub_pub(comm[2])
      when "destroy" then destroy_pub(comm[2])

      end
    end

    def pub_node
      @pub_node ||= "pubsub." + client.jid.domain
    end

    def create_pub(name)
      client.write Blather::Stanza::PubSub::Create.new(:set,
        pub_node, name) { |n| yield n if block_given? }
      PUBSUB[:pubs] << name
      "Done."
    end

    def publish_pub(name, *text)
      client.write Blather::Stanza::PubSub::Publish.new(pub_node, name, :set, text.join)
      text.join
    end

    def list_pub(name)
      client.write Blather::Stanza::PubSub::Items.request(pub_node, name)
    end

    def destroy_pub(name)
      client.write Blather::Stanza::PubSubOwner::Delete.new(:set, pub_node, '/' + name)
      PUBSUB[:pubs] -= [name]
      "Done."
    end

    def all_pubs
      call = Blather::Stanza::DiscoItems.new
      call.to = pub_node
      client.write call
    end

    def my_pubs
      out = "--- Pubsubs\n"
      out << "Owner: #{PUBSUB[:pubs].join(', ')}\n" unless PUBSUB[:pubs].empty?
      out << "Subscribed: #{PUBSUB[:subs].join(', ')}\n" unless PUBSUB[:subs].empty?
      out == "" ? "No PubSubs." : out
    end

    def sub_pub(pub)
      client.write Blather::Stanza::PubSub::Subscribe.new(:set, pub_node, '/' + pub, client.jid.stripped)
      PUBSUB[:subs] << pub
    end

    def unsub_pub(pub)
      client.write Blather::Stanza::PubSub::Unsubscribe.new(:set, pub_node, '/' + pub, client.jid.stripped)
      PUBSUB[:subs] -= [pub]
    end

    def fetch_pubs
      client.write Blather::Stanza::PubSub::Affiliations.new(:get, pub_node)
      client.write Blather::Stanza::PubSub::Subscriptions.new(:get, pub_node)
    end

    def alert_peers(msg)
      PEERS.each do |peer|
        client.write Blather::Stanza::Message.new(peer, msg)
      end
    end

    def process_items(items)
      items.map do |item|
        "\nItem: #{item.payload.strip}"
      end
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
        ROSTER << [client.roster.items.keys, Opt.groups].flatten.uniq
        ROSTER.flatten!
        ROSTER.select { |j| j =~ /\@conference\./ }.each do |c|
          presence = Blather::Stanza::Presence.new
          presence.to = "#{c}/#{Opt.hostname}"
          client.write presence
        end

        fetch_pubs
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
          puts "[PUB ITEM] =>  #{af.inspect}"
          PUBSUB[:pubs] = af[1].map { |p| p.gsub(/\//, '') }
        end
      end

      client.register_handler :pubsub_subscriptions, :subscriptions do |m|
        puts "[SUB] =>  #{m.inspect}"
        m.each do |af|
          puts "[SUB ITEM] =>  #{af.inspect}"
          PUBSUB[:subs] = af[1].map { |p| p[:node].gsub(/\//, '') }
        end
      end

      client.register_handler :pubsub_event, :items do |m|
        puts "[PUBSUB EV] => #{m.inspect}"
        alert_peers "PubSub: #{m.node} #{process_items(m.items)}"
      end

      client.register_handler :pubsub_items, :items do |m|
        puts "[PUBSUB ITEMS] => #{m.inspect}"
        alert_peers "PubSub: #{m.node} #{process_items(m.items)}"
      end

      client.register_handler :disco_items do |r|
        puts "[ITEM] => #{r}"
        # Pub.delete_all
        # PubItem.delete_all
        for item in r.items
          puts "[IT] => #{item.name} on #{item.node.class}"
          # next if item.name =~ /^home$/
          if item.node =~ /\//
            puts "[PUBSUB] => #{item.name} on #{item.node}"
            alert_peers item.name
          else
            if item.jid.to_s =~ /conference\./
              puts "[GROUP] => #{item.name} on #{item.node}"
            else
              puts "[USER] => #{item.jid} name #{item.name}"
            end
          end
        end
      end

      client.register_handler :message, :groupchat? do |m|
        if m.body =~ Regexp.new(Opt.hostname)
          body = m.body.split(":")[-1].strip
        else
          body = m.body
        end
        if m.body =~ /^!|^>|^\\|#{Opt.hostname}/ && m.to_s !~ /x.*:delay/ #delay.nil?
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

      EM.run do
        client.run
        if @report != 0
          puts "will report..."
          # TODO
          # EM.add_periodic_timer(@report) do
          #   puts " I'm ok.. "
          #   client.write Blather::Stanza::Message.new(
          #       "nofxx@Jah.host.com", Jah::Command.quick_results)
          # end
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
