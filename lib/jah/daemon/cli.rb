#
# Jah Gem CLI
#

#TODO: def init
require "eventmachine"#autoload :Client,

module Jah
module Daemon
  class CLI

    def self.parse_options(argv)
      options = {}

      ARGV.options do |opts|
        opts.banner = <<BANNER
Jah Gem Usage:

jah [command] [opts]

Commands:

   start/stop/restart    Daemon control
   config                Run install

BANNER
        opts.separator "Config file:"
        opts.on("-c", "--config CONFIG", String, "Jah Config file path" ) { |file|  options[:config] = file }
        opts.separator ""
        opts.separator "Operation mode:"
        opts.on("-m", "--mode MODE", String, "Jah operation mode")   { |val| options[:mode] = val.to_sym }
        opts.separator ""
        opts.separator "   xmpp   -  Use xmpp client, requires JID and Password"
        opts.separator "   post   -  Use post client, requires Jah Web Key"
        opts.separator "   dump   -  Just dump to disk, Jah Web can login and read"
        opts.separator ""
        opts.separator "Server Options:"
        opts.on("-j", "--jid JID", String, "Client JID (user@domain)")   { |val| options[:jid] = val }
        opts.on("-k", "--key KEY", String, "Client XMPP Password or Jah Web Key")   { |val| options[:key] = val }
        opts.on("-s", "--server SERVER", String, "Jah Server URL" ) { |url|  options[:server] = url }
        opts.on("-p", "--port PORT", Integer, "Jah Server Port")  { |val| options[:port] = val.to_i }
        opts.separator ""

        opts.on("-t", "--talk TALK", String, "Which locale to use" ) { |i18n|  options[:i18n] = i18n }
        opts.on("-f", "--file FILE", String, "Local temp file to track history" ) { |file|  options[:history] = file }
        opts.on("-i", "--interval INTERVAL", Integer, "Poller interval")   { |val| options[:interval] = val.to_i }
        opts.on("-l", "--level LEVEL", Logger::SEV_LABEL.map { |l| l.downcase }, "The level of logging to report" ) { |level| options[:level] = level }
        opts.on("-g", "--[no-]god", "Don't use god")   { |val| options[:god] = false }
        opts.on("-d", "--daemonize", "Run in background" ) { |d|  options[:daemon] = d }
        opts.on("-r", "--report REPORT", "Report status to others on roster" ) { |r|  options[:report] = r }

        opts.separator ""
        opts.separator "Common Options:"
        opts.on("-h", "--help", "Show this message" ) { puts opts; exit }
        opts.on("-v", "--verbose", "Turn on logging to STDOUT" ) { |bool| options[:verbose] = bool }
        opts.on("-V", "--version", "Show version") { |version|  puts "Jah #{Jah::VERSION}";  exit }
        opts.separator ""
        begin
          opts.parse!
          @usage = opts.to_s
        rescue
          puts opts
          exit
        end
      end
      options
    end
    private_class_method :parse_options

    def self.work(argv)
      trap(:INT)  { stop! }
      trap(:TERM) { stop! }

      Opt.autoload_config(parse_options(argv))

      if comm = argv.shift
        Jah::Agent.send(comm) rescue puts "Command not found: #{comm} #{@usage}"
      else
        Opt.mode ? Jah::Agent.start : Install.new
      end
    end

    def self.stop!
      puts "Closing Jah..."
      Opt.closing_time!
      EM.stop
    end

  end

end
end
