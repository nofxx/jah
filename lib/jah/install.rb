#
#  Jah Install Wizard
#
# TODO: i18n
#
module Jah
  class Install < Cli

    #
    #  MODE
    #
    #
    def get_mode
            puts <<-END_MODE.gsub(/^ {8}/, "")
=== Jah Gem Install ===

Hello, thanks for trying Jah!

Looks like #{Jah.hostname} doesn`t have a config file, shall we create one?

Jah needs to know how it will run: xmpp, post or dump.

END_MODE
      mode = nil
      print "Enter mode: "
      while mode.nil?
        mode = case gets.to_s.strip
                when /xmpp/i then :xmpp
                when /post/i then :post
                when /dumpp/i then :dump
                else print "Valid: xmpp, post or dump: "; nil
                end
      end
      @config[:mode] = mode
    end

    #
    #  JID
    #
    #
    def get_jid

      puts <<-END_INTRO.gsub(/^ {8}/, "")

== XMPP JID ==

Good choice! Now we need this server JID.
Tip: You can create it on God Web.
It looks like:

      niceserver@cooldomain.com

END_INTRO
      print "Enter the Client JID: "
      @config[:jid] = gets.to_s.strip
    end

    #
    #  PASS
    #
    #
    def get_pass
      puts <<-END_INTRO.gsub(/^ {8}/, "")

== XMPP Password ==

END_INTRO
      print "Your XMPP client password: "
      @config[:key] = gets.to_s.strip
    end

    #
    #  KEY
    #
    #
    def get_key
      puts <<-END_INTRO.gsub(/^ {8}/, "")

== Jah Web Key ==

You need the Key displayed in the server page.
It looks like:

      5e89c3c3035c8c1ee1b52dce81eee6

END_INTRO
      print "Enter the Client Key: "
      @config[:key] = gets.to_s.strip
    end

    #
    #  HOST
    #
    #
    def get_host
      puts <<-END_INTRO.gsub(/^ {8}/, "")

== Domain ==

Enter the domain Jah will use for XMPP connect and conference search.

END_INTRO
      print "Your host address"
      print @config[:jid] ? " (#{@config[:jid].split("@")[1]}):" : " :"
      @config[:host] = gets.strip
    end

    #
    #  ACL
    #
    #
    def get_acl
      puts <<-END_INTRO.gsub(/^ {8}/, "")

== Access Control List ==

Please enter the JIDs you want Jah to talk to.
Use commas to separate multiple ones.

END_INTRO
      print "ACL: "
      @config[:acl] = gets.strip
    end

    #
    #  GROUPS
    #
    #
    def get_groups
      puts <<-END_INTRO.gsub(/^ {8}/, "")

== Groups (Chats) ==

Please enter the conference room(s) Jah should log in.
Use commas to separate multiple ones.

END_INTRO
      print "Groups: "
      @config[:groups] = gets.strip
    end


    #
    #  GOD
    #
    #
    def use_god?
      puts <<-END_INTRO.gsub(/^ {8}/, "")

== God Config ==

END_INTRO
      print "Use God? (Y/n): "
      @config[:god] = gets.to_s.strip == "n" ? false : true
    end

    #
    #  EVAL
    #
    #
    def use_eval?
      puts <<-END_INTRO.gsub(/^ {8}/, "")

== Eval Ruby ==

Do you want to eval ruby code, using an ! in front of a command?

END_INTRO
      print "Use Eval? (Y/n): "
      @config[:eval] = gets.to_s.strip == "n" ? false : true
    end

    #
    #  REPORTS
    #
    #
    def do_reports?
      puts <<-END_INTRO.gsub(/^ {8}/, "")

== Reports ==

Report my status from time to time to ppl on the roster?

END_INTRO
      print "Report interval in seconds (0 to disable): "
      @config[:report] = gets.to_s.strip.to_i
    end

    #
    #  SUCCESS!
    #
    #
    def success!
      puts <<-END_SUCCESS.gsub(/^ {10}/, "")

== Success! ==

Jah has been setup and it`s running.

END_SUCCESS
    daemon = gets.to_s.strip
    end

    #
    #  CRONTAB
    #
    #
    def show_crontab
      puts <<-CRON

If you are using the system crontab
(usually located at /etc/crontab):

****** START CRONTAB SAMPLE ******
*/30 * * * * #{user} #{program_path} #{key}
****** END CRONTAB SAMPLE ******

If you are using this current user's crontab
(using crontab -e to edit):

****** START CRONTAB SAMPLE ******
*/30 * * * * #{program_path} #{key}
****** END CRONTAB SAMPLE ******

For help setting up Scout with crontab, please visit:

http://scoutapp.com/help#cron

CRON
    end


    #
    #  DUCK TALK
    #
    #
    def duck_talk
      locs = I18n.available_locales.map { |l| l.to_s.downcase }
      puts <<-END_SUCCESS.gsub(/^ {10}/, "")
== Machine Personality ==

Jah goes a lil further than localization, you can make your machine talk to
you like a lady, R2D2, el chespirito, who knows... fork me and add one!

Available options:

* #{locs.join("\n* ")}

END_SUCCESS
      print "Choose one (#{Jah.locale}): "
      @config[:i18n] = gets.to_s.strip.downcase
      @config[:i18n] = Jah.locale if @config[:i18n] == ""
    end


    #
    #  FAIL
    #
    #
    def fail!
      puts <<-END_ERROR.gsub(/^ {10}/, "")

Could not contact server. The client key may be incorrect.
For more help, please visit:

http://jahurl.com/help

END_ERROR
    end

    def write_down
      outfile = "jah.yaml"
      template = File.read(File.join(File.dirname(__FILE__), '..', 'jah.yaml.template'))
      outfile =  File.writable?("/etc/") ? "/etc/" + outfile : HOME + outfile
      puts "Writing config to #{outfile}.."
      @config.keys.each { |k| template.gsub!(/#{k.to_s.upcase}/, @config[k].to_s) }
      File.open(outfile, "w") { |f| f.write template }
    end

    def run
      abort usage unless $stdin.tty?
      @config = {}
      @config[:host] = Jah.hostname
      get_mode
      if @config[:mode] == :xmpp
        @config[:host] = ''
        get_jid
        get_pass
      end
      if @config[:mode] == :post
        @config[:jid] = ''
        get_key
      end
      unless use_god?
        unless daemonize?
          show_crontab
        end
      end
      get_host
      get_acl
      get_groups
      use_eval?
      duck_talk
      do_reports?
      @config[:debug] = :info
      puts ""
      puts "== Writing Config File =="
      puts ""
      write_down

      success!


      #puts "\nAttempting to contact the server..."
      #begin
      #  Jah::Server.new(server, key, history, log) { |scout| scout.test }
      #end
      # rescue SystemExit

      #  end
    end
  end
end
