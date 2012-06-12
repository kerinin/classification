module Pest::Estimator 
  def distributions
    @distributions ||= DistributionList.new(self)
  end

  def to_variable(arg)
    variable = case arg.class.name
    when 'Pest::Variable'
      arg
    when 'String', 'Symbol'
      variables[arg] || Pest::Variable.new(:name => arg)
    end
    raise ArgumentError unless variables.values.include?(variable)
    variable
  end

  class Distribution
    attr_reader :variables

    def initialize(estimator, variables)
      @estimator = estimator
      @variables = variables
    end
  end

  class DistributionList < Hash
    def initialize(estimator)
      @estimator = estimator
    end

    def parse_args(args)
      Array(args).flatten.map {|arg| @estimator.to_variable(arg) }.to_set
    end

    def [](*args)
      set = parse_args(args)
      unless has_key? set
        self[set] = Distribution.new(self, set)
      end
      super(set)
    end
  end
end
