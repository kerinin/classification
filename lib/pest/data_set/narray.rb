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
    data_set = to_na(hash.keys.sort.map {|key| hash[key]}) # Ensure the matrix is sorted the same as the variables
    data_set.variables = {}
    hash.keys.each do |key|
      variable = key.kind_of?(Pest::Variable) ? key : Pest::Variable.new(:name => key)
      data_set.variables[variable.name] = variable
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
    variables.values.each_index do |i|
      hash[variables.values[i]] = self[true,i].to_a[0]
    end
    hash
  end

  # variables: an array of variables for which each vector should contain values
  # Order is retained in the returned value
  def data_vectors(variables=nil)
    VectorEnumerable.new(self, variables)
  end

  def length
    shape[0]
  end

  def save(file=nil)
    file ||= Tempfile.new('pest_hash_dataset')
    file = File.open(file, 'w') if file.kind_of?(String)
    Marshal.dump([variables,to_a], file)
    file.close
  end

  class VectorEnumerable
    include Enumerable

    def initialize(data_set, variables = true)
      @data_set = data_set
      @variables = variables
      if @variables.kind_of?(Enumerable)
        @variables = variables.map {|v| @data_set.variable_array.index(v)}
      end
    end

    def [](i)
      @data_set[i,@variables].transpose
    end

    def each
      (0..@data_set.shape[0]-1).each do |i|
        yield Array(self[i]).first
      end
    end
  end
end
