module Pest::Function
  module Entropy
    def entropy(*variables)
      Builder.new(self, variables)
    end
    alias :h :entropy

    class Builder
      include Pest::Function::Builder

      attr_reader :estimator, :event, :givens

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
    end
  end
end
