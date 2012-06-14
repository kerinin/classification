class Pest::Estimator::Set::Frequency
  include Pest::Estimator::Set

  def distribution_class
    Distribution
  end

  class Distribution
    include Pest::Estimator::Distribution

    attr_reader :frequencies, :checksum

    def cache_model
      @checksum = @estimator.data.hash

      @frequencies = Hash.new(0)
      @estimator.data.each_vector(@variables) do |vector|
        @frequencies[vector] += 1
      end

      Marshal.dump @self, Tempfile.new("#{@checksum}.#{@variables.hash}")
    end
  end
end
