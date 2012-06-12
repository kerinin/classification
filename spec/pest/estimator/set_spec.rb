require 'spec_helper'

class TestClass
  include Pest::Estimator::Set
end

describe Pest::Estimator::Set do
  it "inherits from Estimator" do
    TestClass.new.should be_a(Pest::Estimator)
  end

  it "inherits from Probability" do
    TestClass.new.should be_a(Pest::Function::Probability)
  end

  it "inherits from Entropy" do
    TestClass.new.should be_a(Pest::Function::Entropy)
  end
end
