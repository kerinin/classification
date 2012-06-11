require 'spec_helper'

describe Pest::Estimator::Set::Bernoulli do
  it "inherits from set"

  describe "estimate_class" do
    before(:each) { @instance = Pest::Estimator::Set::Bernoulli.new }

    it "returns class" do
      @instance.estimate_class.should == Pest::Estimate::Set::Bernoulli
    end
  end
end
