$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require "pest/version"
require "pest/variable"
require "pest/data_set"
require "pest/estimator"
require "pest/estimate"
require "pest/data_set/hash"

module Pest
end
