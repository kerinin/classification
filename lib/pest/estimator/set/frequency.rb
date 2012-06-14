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
      if csum and csum == @checksum and file = find_tempfile
        @frequencies = Marshal.restore(file)
      else
        @checksum = csum

        @frequencies = Hash.new(0)
        # NOTE: This needs to be filtering the vectors by variable, and it's not...
        @estimator.data.vectors.each do |vector|
          @frequencies[vector] += 1
        end

        Marshal.dump @frequencies, Tempfile.new("#{@checksum}.#{@variables.hash}")
      end
    end

    private

    def find_tempfile
      if path = Dir.glob("#{Dir::Tmpname.tmpdir}/*").select {|path| path =~ /#{@checksum}\.#{@variables.hash}/}.first
        File.open(path)
      end
    end
  end
end
