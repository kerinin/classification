require 'spec_helper'

describe Pest::Functions::Entropy do
  it "inherits from numeric"

  describe "new" do
    it "sets estimator"
    it "sets variables"
    it "fails if variable undefined for estimator"
  end

  describe "estimator" do
    it "returns parent estimator"
  end

  describe "variables" do
  end

  describe "givens" do
  end

  # given(:foo => :bar)
  describe "given" do
    it "sets givens"
    it "returns self"
    it "fails if not passed a list"
    it "fails if arguments aren't variables on the estimator"
  end

  describe "evaluate" do
    it "gets entropy of variables"
    it "gets entropy of givens"
    it "returns H event / givens (if givens)"
    it "returns H event (if no givens)"
  end

  # Test that most functions trigger evaluate + super
end
