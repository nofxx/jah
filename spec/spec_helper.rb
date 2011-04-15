$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'jah'
require 'rspec'
include Jah

RSpec.configure do |config|
  #config.mock_with :rr

end
