require 'spec_helper'
require 'gsl'

# NOTE: Figure out how to instantiate these things
# cause calling [] on the Matrix class isn't it.
# looks like 'alloc' is your best option
#
describe Pest::DataSet::GSL do
  before(:each) do
    @class = Pest::DataSet::GSL
  end

  it "inherits from GSL::Matrix" do
    @class.new.should be_a(GSL::Matrix)
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
      @matrix = GSL::Matrix[[1,2,3],[4,5,6]]
      @file = File.open(Tempfile.new('test').path, 'w')
      @matrix.fwrite(@file)
    end

    it "loads from GSL IO" do
      @class.from_file(@file).should == @matrix
    end

    it "looks for GSL from string" do
      @class.from_file(@file.path).should == @matrix
    end
      
    it "sets variables" do
      @class.from_file(@file).variables.should == [0,1,2]
    end
  end

  describe "self.from_hash" do
    before(:each) do
      @v1 = Pest::Variable.new(:name => :foo)
      @v2 = Pest::Variable.new(:name => :bar)
      @matrix = GSL::Matrix[[1,2,3],[4,5,6]]
    end

    it "creates a GSL::Matrix" do
      @class.from_hash({@v1 => [1,2,3], @v2 => [4,5,6]}).should == @matrix
    end

    it "sets variables" do
      @class.from_hash({@v1 => [1,2,3], @v2 => [4,5,6]}).variables.should == [@v1, @v2]
    end
  end

  describe "to_hash" do
    before(:each) do
      @instance = @class[[1,2,3], [4,5,6]]
    end

    it "sets keys" do
      @instance.to_hash.keys.should == @instance.keys
    end

    it "sets values" do
      @instance.to_hash.values.should == [[1,2,3],[4,5,6]]
    end
  end

  describe "save" do
    before(:each) do
      @instance = @class[[1,2,3],[4,5,6]]
    end

    it "saves to GSL file" do
      GSL::Matrix.should_receive(:fwrite).with('foo')
      @instance.save('foo')
    end

    it "saves to tmp dir if no filename specified" do
      GSL::Matrix.should_receive(:fwrite).with(kind_of(Tempfile))
      @instance.save('foo')
    end
  end
end
