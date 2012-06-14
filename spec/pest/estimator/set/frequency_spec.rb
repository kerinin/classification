require 'spec_helper'

describe Pest::Estimator::Set::Frequency do
  before(:each) do
    @class = Pest::Estimator::Set::Frequency
    @data = Pest::DataSet::NArray.from_hash :foo => [1,1,2,3], :bar => [1,1,1,1]
    @instance = @class.new(@data)
  end

  it "inherits from set" do
    @instance.should be_a(Pest::Estimator::Set)
  end

  describe Pest::Estimator::Set::Frequency::Distribution do
    before(:each) do
      @dist = @instance.distributions[@data.variables.values.to_set]
    end

    describe "cache_model" do
      it "checksums the data" do
        @data.should_receive(:hash).and_return(2938238)
        @dist.cache_model
      end
      
      context "with unrecognized checksum" do
        it "determines vector frequency" do
          @dist.cache_model
          @dist.frequencies[[1,1]].should == 2
          @dist.frequencies[[2,1]].should == 1
          @dist.frequencies[[3,1]].should == 1
        end

        it "defaults to 0" do
          @dist.cache_model
          @dist.frequencies[[4,1]].should == 0
        end
          
        it "saves to temp file" do
          @file = Tempfile.new('test')
          Tempfile.should_receive(:new).with(/#{@data.hash}/).and_return(@file)
          @dist.cache_model
        end

        it "sets the cached checksum" do
          @dist.cache_model
          @dist.checksum.should == @data.hash
        end
      end

      context "with recognized checksum but no file" do
        before(:each) do
          File.delete @dist.cache_model
        end

        it "determines vector frequency" do
          @data.should_receive(:vectors)
          @dist.cache_model
        end

        it "saves to temp file" do
          @file = Tempfile.new('test')
          Tempfile.should_receive(:new).with(/#{@dist.checksum}/).and_return(@file)
          @dist.cache_model
        end
      end

      context "with recognized checksum and cache file" do
        before(:each) do
          @file = @dist.cache_model
        end

        it "loads the data from file" do
          Marshal.should_receive(:restore).with(kind_of(File))
          @dist.cache_model
        end
      end
    end

    describe "evaluate" do
      it "calculates vector frequency / dataset length" 
      it "return NArray"
    end
  end
end
