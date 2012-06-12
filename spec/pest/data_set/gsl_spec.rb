require 'spec_helper'

describe Pest::DataSet::GSL do
  describe "self.translators" do
    it "maps Pest::DataSet::Hash => from_hash"
    it "maps File => from_file"
    it "maps String => from_file"
  end

  describe "self.from_file" do
    it "loads from saved GSL file"
    it "looks for file if passed string"
    it "sets variables"
  end

  describe "self.from_hash" do
    it "saves to tempfile"
    it "sets filename"
    it "sets variables"
  end

  describe "to_hash" do
  end

  describe "save" do
    it "saves to GSL file"
    it "saves to tmp dir if no filename specified"
  end
end
