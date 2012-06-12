require 'spec_helper'

class TestClass
  include Pest::Estimator
end

describe Pest::Estimator do
  describe "estimates" do
    before(:each) do
      @v1 = Pest::Variable.new(:name => :foo)
      @v2 = Pest::Variable.new(:name => :bar)
      @v3 = Pest::Variable.new(:name => :baz)

      @instance = TestClass.new
      @instance.stub(:variables).and_return({:foo => @v1, :bar => @v2})
    end

    it "accepts a set of variables" do
      @instance.distributions[@v1, @v2].should be_a(Pest::Estimator::Distribution)
    end

    it "returns an estimator for the passed variables" do
      @instance.distributions[@v1, @v2].variables.should == [@v1, @v2].to_set
    end

    it "returns an estimator for the passed strings" do
      @instance.distributions[:foo, :bar].variables.should == [@v1, @v2].to_set
    end

    it "is variable order agnostic" do
      @instance.distributions[@v1, @v2].should == @instance.distributions[@v2, @v1]
    end

    it "fails if a set variable isn't defined" do
      lambda { @instance.distributions[@v1, @v3] }.should raise_error(ArgumentError)
    end
  end

  describe Pest::Estimator::Distribution do
    describe "cache_model" do
      it "raises no implemented"
    end

    describe "probability" do
      it "raises no implemented"
    end
  end
end
