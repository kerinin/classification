require 'spec_helper'

describe Pest::Estimator::Continuous::SVD do
  it "inherits from continuous"

  describe "estimate_class" do
    before(:each) { @instance = Pest::Estimator::Continuous::SVD.new }

    it "returns class" do
      @instance.estimate_class.should == Pest::Estimate::Continuous::SVD
    end
  end
end
