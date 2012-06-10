require 'spec_helper'

describe Pest::Variable do
  describe "type" do
    it "returns the type class"
    it "defaults to 'float'"
    it "allows [boolean,string,integer,float]"
  end

  describe "uuid" do
  end

  describe "name" do
  end

  describe "identifier" do
    it "concatenates name:type:uuid"
    it "is aliased as serialize"
  end

  describe "==" do
    it "compares identifier"
  end

  describe "self.deserialize" do
    it "instantiates with name"
    it "instantiates with type"
    it "instantiates with uuid"
  end
end
