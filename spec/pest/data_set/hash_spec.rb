require 'spec_helper'

describe Pest::DataSet::Hash do
  context "class methods" do
    before(:each) do
      @class = Pest::DataSet::Hash
    end

    describe "self.translators" do
      it "maps File => from_file" do
        @class.translators[File].should == :from_file
      end

      it "maps String => from_file" do
        @class.translators[String].should == :from_file
      end

      it "maps Symbol => from_file" do
        @class.translators[Symbol].should == :from_file
      end
    end

    describe "self.from_file" do
      before(:each) do
        file = File.open(__FILE__, 'r')
        File.stub(:open).with('foo', 'r').and_return(file)
        Marshal.stub(:restore).with(file).and_return({:foo => 1})
      end

      it "looks for file if passed string" do
        File.should_receive(:open).with('foo', 'r')
        @class.from_file('foo')
      end

      it "unmarshals" do
        Marshal.should_receive(:restore)
        @class.from_file('foo')
      end

      it "sets variables" do
        @class.from_file('foo').variables.length.should == 1
      end

      it "generates variables" do
        @class.from_file('foo').variables.first.should be_a(Pest::Variable)
      end
    end
  end

  before(:each) do
    @data = {:foo => [1,2,3], :bar => [3,4,5]}
    @instance = Pest::DataSet::Hash.new(@data)
  end

  describe "to_hash" do
    it "returns a hash" do
      @instance.to_hash.should == @data
    end
  end

  # Required
  describe "save" do
    before(:each) do
      @file = File.open(__FILE__, 'r')
      File.stub(:open).with('foo', 'w').and_return(@file)
      Marshal.stub(:dump)
    end

    it "marshals to file from path" do
      Marshal.should_receive(:dump).with(@data, @file)
      @instance.save('foo')
    end

    it "marshals to file from file" do
      Marshal.should_receive(:dump).with(@data, @file)
      @instance.save(@file)
    end

    it "saves to tmp dir if no filename specified" do
      File.should_receive(:open).with(/pest_hash_dataset/, anything(), anything()).and_return(@file)
      @instance.save
    end
  end

  describe "length" do
    it "delegates to hash" do
      pending "how to handle values with different lengths"
    end
  end
end
