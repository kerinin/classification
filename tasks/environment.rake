task :environment do
  require File.join(File.dirname(__FILE__), "..", "lib", "classification.rb")
  require File.join(File.dirname(__FILE__), "..", "lib", "rake_helpers.rb")
  require 'pry'

  include Classification
  include RakeHelpers
end
