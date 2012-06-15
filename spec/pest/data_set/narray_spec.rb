require 'spec_helper'
require 'narray'

describe Pest::DataSet::NArray do
  before(:each) do
    @v1 = Pest::Variable.new(:name => :foo)
    @v2 = Pest::Variable.new(:name => :bar)
    @class = Pest::DataSet::NArray
  end

  describe "self.translators" do
    it "maps Pest::DataSet::Hash => from_hash" do
      @class.translators[Pest::DataSet::Hash].should == :from_hash
    end

    it "maps File => from_file" do
      @class.translators[File].should == :from_file
    end

    it "maps String => from_file" do
      @class.translators[String].should == :from_file
    end
  end

  describe "self.from_file" do
    before(:each) do
      @matrix = @class.from_hash @v1 => [1,2,3], @v2 => [4,5,6]
      @file = Tempfile.new('test')
      @matrix.save(@file.path)
    end

    it "loads from NArray IO" do
      @class.from_file(@file).should == @matrix
    end

    it "looks for NArray from string" do
      @class.from_file(@file.path).should == @matrix
    end
      
    it "sets variables" do
      @class.from_file(@file).variables.values.should == [@v1, @v2]
    end
  end

  describe "self.from_hash" do
    before(:each) do
      @matrix = NArray.to_na [[1,2,3],[4,5,6]]
    end

    it "creates a NArray" do
      @class.from_hash({@v1 => [1,2,3], @v2 => [4,5,6]}).should == @matrix
    end

    it "sets variables" do
      @class.from_hash({@v1 => [1,2,3], @v2 => [4,5,6]}).variables.values.should == [@v1, @v2]
    end

    it "generates Pest::Variables if not passed" do
      @class.from_hash({:foo => [1,2,3]}).variables[:foo].should be_a(Pest::Variable)
    end
  end

  describe "to_hash" do
    before(:each) do
      @instance = @class.from_hash :foo => [1,2,3], :bar => [4,5,6]
    end

    it "sets keys" do
      @instance.to_hash.keys.should == @instance.variables.values
    end

    it "sets values" do
      @instance.to_hash.values.should == [[1,2,3],[4,5,6]]
    end
  end

  describe "data_vectors" do
    before(:each) do
      @instance = @class.from_hash :foo => [1,2,3], :bar => [4,5,6]
    end

    it "returns an enumerable" do
      @instance.data_vectors.should be_a(Enumerable)
    end

    it "slices" do
      # NOTE: This is returning an array - probably could be more efficient
      @instance.data_vectors.first.should == [1,4]
    end
  end

  describe "save" do
    before(:each) do
      @file = Tempfile.new('test')
      @instance = @class.from_hash :foo => [1,2,3], :bar => [4,5,6]
    end

    it "marshals to file" do
      @instance.save(@file)
      @class.from_file(@file.path).should == @instance
    end

    it "saves to tmp dir if no filename specified" do
      Tempfile.should_receive(:new).and_return(@file)
      @instance.save
      @class.from_file(@file.path).should == @instance
    end
  end
end
