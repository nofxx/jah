require "rubygems"
require "optparse"
begin
  require "i18n"
rescue LoadError
  puts "Gem 'i18n' not found, try `gem install i18n`"
  exit
end
#autoload :Drb, "drb"
require "jah/opt"
require "jah/cli"
require "jah/install"
require "jah/agent"
require "jah/history"
autoload :God, "god"
autoload :Prayer, "jah/prayer"
require "jah/command"
%w{mem cpu who disk prok netstat admin status extra packages}.each do |inc|
  require "jah/commands/#{inc}"
end
require "jah/act_pkg"
require "jah/act_pkg/base"
require "jah/act_pkg/pkg"

module Jah
  VERSION =  File.read(File.join(File.dirname(__FILE__), "..", "VERSION"))
  I18n.load_path += Dir[File.join(File.dirname(__FILE__), "locales", "*.{rb,yml}")]
end
