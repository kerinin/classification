require 'spec_helper'

describe Pest::Estimator::Set::Simple do
  it "inherits from set"

  describe "estimate_class" do
    before(:each) { @instance = Pest::Estimator::Set::Simple.new }

    it "returns class" do
      @instance.estimate_class.should == Pest::Estimate::Set::Simple
    end
  end
end
