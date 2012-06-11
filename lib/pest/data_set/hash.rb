class Pest::DataSet::Hash
  include Pest::DataSet

  def self.translators
    {
      File    => :from_file,
      String  => :from_file,
      Symbol  => :from_file
    }
  end

  def self.from_file(file)
    file = File.open(file.to_s, 'r') if file.kind_of?(String)

    object = Marshal.restore(file)

    if object.kind_of?(::Hash)
      self.new(object)
    else
      raise "File does not seem to contain valid data"
    end
  end

  def initialize(hash)
    @hash = hash
    @variables = {}
    hash.keys().each do |name|
      @variables[name] = Pest::Variable.new(:name => name)
    end
  end

  def to_hash
    @hash
  end

  def save(file=nil)
    file ||= Tempfile.new('pest_hash_dataset')
    file = File.open(file, 'w') if file.kind_of?(String)
    Marshal.dump(@hash, file)
  end
end
