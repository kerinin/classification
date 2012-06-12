require 'gsl'

class Pest::DataSet::GSL < GSL::Matrix
  include Pest::DataSet

  def self.translators
    {
      Hash    => :from_hash,
      File    => :from_file,
      String  => :from_file,
      Symbol  => :from_file
    }
  end

  def self.from_hash(hash)
  end

  def self.from_file(file)
    self.fread(file)
  end

  def to_hash
  end

  def save(file=nil)
    file ||= Tempfile.new('pest_hash_dataset')
    file = File.open(file, 'w') if file.kind_of?(String)
  end
end
