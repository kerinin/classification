require 'narray'

class Pest::Estimator::Set::Frequency
  include Pest::Estimator::Set

  def distribution_class
    Distribution
  end

  class Distribution
    include Pest::Estimator::Distribution

    attr_reader :frequencies, :checksum

    def cache_model
      csum = @estimator.data.hash
      if Pest::CACHE_TO_FILE and csum and csum == @checksum and file = find_tempfile
        @frequencies = Marshal.restore(file)
      else
        @checksum = csum

        @frequencies = Hash.new(0)
        @estimator.data.data_vectors(variable_array).each do |vector|
          # Make sure this vector is consistently ordered
          @frequencies[vector] += 1
        end

        file = Tempfile.new("#{@checksum}.#{@variables.hash}")
        Marshal.dump @frequencies, file
        file.close
      end
    end

    def probability(data)
      cache_model

      NArray[ data.data_vectors(variable_array).map do |vector|
        @frequencies[vector].to_f
      end ] / @estimator.data.length
    end

    def entropy
      cache_model

      probabilities = probability(unique_event_dataset)

      (-probabilities * NMath.log2(probabilities)).sum
    end

    private

    def unique_event_dataset
      vectors = Pest::DataSet::NArray[@frequencies.keys]
      hash = {}
      variable_array.each_index do |i|
        # Extract a single variable from the array of vectors
        hash[variable_array[i]] = vectors[i,true,true].reshape!(vectors.shape[1]).to_a
      end
      Pest::DataSet::NArray.from_hash(hash)
    end

    def find_tempfile
      if path = Dir.glob("#{Dir::Tmpname.tmpdir}/*").select {|path| path =~ /#{@checksum}\.#{@variables.hash}/}.first
        File.open(path)
      end
    end
  end
end
