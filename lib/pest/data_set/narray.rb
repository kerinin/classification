require 'narray'

class Pest::DataSet::NArray < NMatrix
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
    data_set = to_na(hash.values())
    data_set.variables = hash.keys.map do |key|
      key.kind_of?(Pest::Variable) ? key : Pest::Variable.new(:name => key)
    end
    data_set
  end

  def self.from_file(file)
    file = File.open(file.to_s, 'r') if file.kind_of?(String)

    begin
      variables, matrix = Marshal.restore(file)
      data_set = to_na(matrix)
      data_set.variables = variables
      data_set
    rescue
      raise "File does not seem to contain valid data"
    end
  end

  attr_accessor :variables

  def to_hash
    hash = {}
    variables.each_index do |i|
      hash[variables[i]] = self[true,i].to_a[0]
    end
    hash
  end

  def save(file=nil)
    file ||= Tempfile.new('pest_hash_dataset')
    file = File.open(file, 'w') if file.kind_of?(String)
    Marshal.dump([variables,to_a], file)
    file.close
  end
end
