$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'jah'
require 'spec'
require 'spec/autorun'
include Jah

Spec::Runner.configure do |config|
  #config.mock_with :rr

end
