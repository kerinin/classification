module Pest::Estimator 
  def estimates
    @estimates ||= EstimateList.new(self)
  end

  class Distribution
    attr_reader :variables

    def initialize(estimator, variables)
      @estimator = estimator
      @variables = variables
    end
  end

  class EstimateList < Hash
    def initialize(estimator)
      @estimator = estimator
    end

    def parse_args(args)
      Array(args).flatten.map {|arg| to_variable(arg) }.to_set
    end

    def to_variable(arg)
      variable = case arg.class.name
      when 'Pest::Variable'
        arg
      when 'String', 'Symbol'
        @estimator.variables[arg] || Pest::Variable.new(:name => arg)
      end
      raise ArgumentError unless @estimator.variables.values.include?(variable)
      variable
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
