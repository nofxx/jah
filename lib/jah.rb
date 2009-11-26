require 'rubygems'
require 'optparse'
begin
  require 'i18n'
rescue LoadError
  puts "Gem i18n not found. Try `gem install i18n`"
end
#autoload :Drb, 'drb'
require 'jah/opt'
require 'jah/cli'
require 'jah/install'
require 'jah/agent'
require 'jah/history'
autoload :God, 'god'
autoload :Prayer, "jah/prayer"
require 'jah/command'
require "jah/commands/mem"
require "jah/commands/cpu"
require "jah/commands/who"
require "jah/commands/disk"
require "jah/commands/prok"
require "jah/commands/netstat"
require "jah/commands/admin"
require "jah/commands/status"
require "jah/commands/extra"
require "jah/commands/packages"
require "jah/act_pkg"
require "jah/act_pkg/base"
require "jah/act_pkg/pkg"

module Jah
  VERSION =  File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))
  I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'locales', "*.{rb,yml}")]
end
