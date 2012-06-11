require 'spec_helper'

describe Pest::Estimator::Set::Multinomial do
  it "inherits from set"

  describe "estimate_class" do
    before(:each) { @instance = Pest::Estimator::Set::Multinomial.new }

    it "returns class" do
      @instance.estimate_class.should == Pest::Estimate::Set::Multinomial
    end
  end
end
