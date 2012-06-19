require 'spec_helper'

class TestClass
  include Pest::Estimator
  include Pest::Function::Entropy
end

describe Pest::Function::Entropy do
  before(:each) do
    @v1 = Pest::Variable.new(:name => :foo)
    @v2 = Pest::Variable.new(:name => :bar)
    @v3 = Pest::Variable.new(:name => :baz)
    @instance = TestClass.new
    @instance.stub(:variables).and_return({:foo => @v1, :bar => @v2})
  end

  describe "entropy" do
    it "returns a Builder" do
      @instance.entropy.should be_a(Pest::Function::Entropy::Builder)
    end

    it "is aliased as h" do
      @instance.h.should be_a(Pest::Function::Entropy::Builder)
    end
  end

  describe Pest::Function::Entropy::Builder do
    describe "new" do
      before(:each) { @builder = TestClass::Builder.new(@instance, [@v1, :bar]) }

      it "sets estimator" do
        @builder.estimator.should == @instance
      end

      it "sets event" do
        @builder.event.should == [@v1, @v2].to_set
      end

      it "fails if variable undefined for estimator" do
        lambda { TestClass::Builder.new(@instance, [@v1, @v3]) }.should raise_error(ArgumentError)
      end

      it "constructs dataset if passed hash"
    end

    describe "given" do
      before(:each) { @builder = TestClass::Builder.new(@instance, [:foo]) }

      it "sets givens" do
        @builder.given(:bar)
        @builder.givens.should include(@v2)
      end

      it "returns self" do
        @builder.given(:bar).should be_a(TestClass::Builder)
      end

      it "fails if variables aren't variables on the estimator" do
        lambda { @builder.given(:baz) }.should raise_error(ArgumentError)
      end

      it "adds to dataset if passed hash"

      it "raises error if passed hash with existing (non hash) dataset"
    end

    describe "evaluate" do
      it "generates dataset if not specified"

      it "gets entropy of event" do
        event = double('EventDist')
        @instance.distributions.stub(:[]).with([@v1].to_set).and_return(event)
        event.should_receive(:entropy).and_return 0.5

        TestClass::Builder.new(@instance,[:foo]).evaluate
      end

      it "gets entropy of givens" do
        event = double("EventDist")
        given = double("GivenDist")
        @instance.distributions.stub(:[]).with([@v1].to_set).and_return(event)
        @instance.distributions.stub(:[]).with([@v2].to_set).and_return(given)
        event.stub(:entropy).and_return 0.5
        given.should_receive(:entropy).and_return 0.25

        TestClass::Builder.new(@instance,[:foo]).given(:bar).evaluate
      end

      it "returns H event - givens (if givens)" do
        event = double("EventDist")
        given = double("GivenDist")
        @instance.distributions.stub(:[]).with([@v1].to_set).and_return(event)
        @instance.distributions.stub(:[]).with([@v2].to_set).and_return(given)
        event.stub(:entropy).and_return 0.5
        given.stub(:entropy).and_return 0.1

        TestClass::Builder.new(@instance,[:foo]).given(:bar).evaluate.should == 0.4
      end

      it "returns H event (if no givens)" do
        event = double("EventDist")
        @instance.distributions.stub(:[]).with([@v1].to_set).and_return(event)
        event.stub(:entropy).and_return 0.5

        TestClass::Builder.new(@instance,[:foo]).evaluate.should == 0.5
      end
    end
  end
end
