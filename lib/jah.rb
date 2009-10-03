require 'rubygems'
require 'optparse'
require 'i18n'
#autoload :Drb, 'drb'
autoload :God, 'god'
require 'jah/cli'
require 'jah/install'
require 'jah/agent'
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
  VERSION = "0.0.1"

end
