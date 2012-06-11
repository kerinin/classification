# require 'spec_helper'
# 
# describe Pest::Functions::Probability
#   it "inherits from numeric"
# 
#   describe "new" do
#     it "sets estimator"
#     it "sets event"
#     it "tries to construct a dataset if passed something else"
#     it "fails if variable undefined for estimator"
#   end
# 
#   describe "estimator" do
#     it "returns parent estimator"
#   end
# 
#   describe "event" do
#   end
# 
#   describe "givens" do
#   end
# 
#   # given(:foo => :bar)
#   describe "given" do
#     it "sets givens"
#     it "returns self"
#     it "failes if not passed a hash"
#     it "fails if hash keys aren't variables on the estimator"
#   end
# 
#   describe "evaluate" do
#     it "gets probability of event"
#     it "gets probability of givens"
#     it "returns Pr event / givens (if givens)"
#     it "returns Pr event (if no givens)"
#   end
# 
#   # Test that most functions trigger evaluate + super
# end
