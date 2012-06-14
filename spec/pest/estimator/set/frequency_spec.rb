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
        it "determines vector frequency"
        it "saves to temp file"
        it "sets the cached checksum"
      end

      context "with recognized checksum but no file" do
        it "determines vector frequency"
        it "saves to temp file"
      end

      context "with recognized checksum and cache file" do
        it "loads the data from file"
      end
    end

    describe "evaluate" do
      it "calculates vector frequency / dataset length"
      it "return NArray"
    end
  end
end
