require 'rubygems'
require 'optparse'
require 'i18n'
#autoload :Drb, 'drb'
autoload :God, 'god'
require 'jah/cli'
require 'jah/install'
require 'jah/agent'
require 'jah/collector'
require "jah/collectors/mem"
require "jah/collectors/cpu"
require "jah/collectors/who"
require "jah/collectors/disk"
require "jah/collectors/prok"
require "jah/collectors/netstat"
require 'jah/command'
require "jah/commands/admin"
require "jah/commands/status"
require "jah/commands/extra"

module Jah
  VERSION = "0.0.1"

end
