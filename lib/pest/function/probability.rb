module Pest::Function
  module Probability
    def probability(*variables)
      Builder.new(self, variables)
    end
    alias :p :probability

    class Builder
      attr_reader :estimator, :data_source, :event, :givens

      (Object.instance_methods + Rational.instance_methods).each do |f|
        define_method(f) do |*args|
          evaluate.send(f, *args)
        end
      end

      def initialize(estimator, variables)
        @estimator      = estimator
        @data_source    = data_source
        @event          = parse(variables)
        @givens         = [].to_set
      end

      def given(*variables)
        @givens.merge parse(variables)
        self
      end

      def in(data_set)
        @data_source = data_set
        self
      end

      def evaluate
        joint = estimator.distributions[event].probability(data_source)
        if givens.empty?
          joint
        else
          conditional = estimator.distributions[givens].probability(data_source)
          joint / conditional
        end
      end

      private

      def parse(variables)
        variables.map {|arg| estimator.to_variable(arg) }.to_set
      end
    end
  end
end
