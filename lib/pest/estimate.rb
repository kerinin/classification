module Pest::Estimate
  attr_reader :variables

  def initialize(estimator, variables)
    @estimator = estimator
    @variables = variables
  end
end
