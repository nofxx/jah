require 'rubygems'
require 'optparse'
require 'i18n'
#autoload :Drb, 'drb'
require 'jah/cli'
require 'jah/install'
require 'jah/agent'
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

module Jah
  VERSION =  File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))

  # find a better place for this
  I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'locales', "*.{rb,yml}")]
  I18n.default_locale = "en_us"
end
