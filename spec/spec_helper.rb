$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'pry'
require 'classification'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = :documentation
end
