require 'spec_helper'

class TestClass
  include Pest::DataSet
end

describe Pest::DataSet do
  before(:each) { @instance = TestClass.new }

  describe Pest::DataSet::ClassMethods do
    before(:each) { @class = TestClass }

    describe "from" do
      it "calls checks for translator with passed class"
      it "passes to translator if found"
      it "calls to_hash if unrecognized class"
      it "passes to translator after converting to hash"
    end

    describe "translators" do
      # Required
      it "raises an error if called from module"
    end
    
    describe "from_file" do
      # Required
      it "raises an error if called from module"
    end
    
    describe "from_hash" do
      # Required
      it "raises an error if called from module"
    end
  end

  describe "variables" do
    it "defaults to an empty list"
  end

  describe "to_hash" do
    # Required
    it "raises an error if called from module"
  end

  describe "save" do
    # Required
    it "raises an error if called from module"
  end

  describe "destroy" do
    # Required
    it "raises an error if called from module"
  end

  describe "length" do
    # Required
    it "raises an error if called from module"
  end

  # Enumerable interface?
end
