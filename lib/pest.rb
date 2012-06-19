$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'uuidtools'

require "pest/version"
require "pest/variable"

require "pest/function/probability"
require "pest/function/entropy"

require "pest/data_set"
require "pest/data_set/hash"
require "pest/data_set/narray"

require "pest/estimator"
require "pest/estimator/set"
require "pest/estimator/set/frequency"

module Pest
  CACHE_TO_FILE = false
end
