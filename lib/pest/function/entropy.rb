module Pest::Function
  module Entropy
    def entropy(*variables)
      Builder.new(self, variables)
    end
    alias :h :entropy

    class Builder
      attr_reader :estimator, :event, :givens

      # Delegate methods to the result of 'evaluate'
      # (Object.instance_methods + Rational.instance_methods).each do |f|
      #   define_method(f) do |*args|
      #     evaluate.send(f, *args)
      #   end
      # end

      def initialize(estimator, variables)
        @estimator      = estimator
        @event          = parse(variables)
        @givens         = [].to_set
      end

      def given(*variables)
        @givens.merge parse(variables)
        self
      end

      def evaluate
        joint = estimator.distributions[event].entropy
        if givens.empty?
          joint
        else
          conditional = estimator.distributions[givens].entropy
          joint - conditional
        end
      end

      private

      def parse(variables)
        variables.map {|arg| estimator.to_variable(arg) }.to_set
      end
    end
  end
end
