require 'spec_helper'

describe Pest::Variable do
  before(:each) { @class = Pest::Variable }

  describe "#uuid" do
    it "is generated if not specified" do
      @class.new.uuid.should be_true
    end

    it "uses uuid passed at instantiation" do
      @class.new(:uuid => 'foo').uuid.should == 'foo'
    end
  end

  describe "#name" do
    it "has it" do
      @class.new(:name => 'foo').name.should == 'foo'
    end
  end

  describe "#identifier" do
    before(:each) do
      @instance = @class.new(:name => 'foo', :uuid => 'bar')
    end

    it "concatenates name:uuid" do
      @instance.identifier.should == 'foo:bar'
    end

    it "is aliased as serialize" do
      @instance.serialize.should == 'foo:bar'
    end
  end

  describe "#==" do
    before(:each) do
      @one = @class.new(:name => 'foo', :uuid => 'bar')
      @two = @class.new(:name => 'foo', :uuid => 'bar')
      @three = @class.new(:name => 'foo', :uuid => 'baz')
    end

    it "returns true if same identifier" do
      @one.should == @two
    end

    it "returns false if identifier doesn't match" do
      @one.should_not == @three
    end

    it "returns false if not a Variable instance" do
      @one.should_not == 'hello'
    end

    it "works for sets" do
      [@one].to_set.should == [@two].to_set
    end
  end

  describe "::deserialize" do
    before(:each) do
      @instance = @class.deserialize('foo:4f9b5243-2e2e-4a90-8009-21079fad5855')
    end

    it "instantiates with name" do
      @instance.name.should == 'foo'
    end

    it "instantiates with uuid" do
      @instance.uuid.should == '4f9b5243-2e2e-4a90-8009-21079fad5855'
    end
  end
end
