class Pest::Estimator::Set::Frequency
  include Pest::Estimator::Set

  def distribution_class
    Distribution
  end

  class Distribution
    include Pest::Estimator::Distribution

    def cache_model
      @checksum = @estimator.data.hash
    end
  end
end
