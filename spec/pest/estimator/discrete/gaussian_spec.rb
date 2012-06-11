require 'spec_helper'

describe Pest::Estimator::Discrete::Gaussian do
  it "inherits from discrete"

  describe "estimate_class" do
    before(:each) { @instance = Pest::Extimator::Discrete::Gaussian.new }

    it "returns class" do
      @instance.estimate_class.should == Pest::Estimate::Discrete::Gaussian
    end
  end
end
