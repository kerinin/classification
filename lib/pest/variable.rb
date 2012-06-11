require 'uuidtools'

class Pest::Variable

  def self.deserialize(string)
    if string.chomp =~ /^([^\:]+)\:(\w+)\:(\w{8}-\w{4}-\w{4}-\w{4}-\w{12})$/
      new :name => $1, :type => Kernel.const_get($2), :uuid => $3
    else
      raise "Unable to parse string"
    end
  end

  attr_reader :name, :type, :uuid

  def initialize(args={})
    @name = args[:name]
    @type = args[:type] || Float
    @uuid = args[:uuid] || UUIDTools::UUID.random_create
  end

  def identifier
    "#{name}:#{type.name}:#{uuid}"
  end
  alias :serialize :identifier

  def ==(other)
    other.kind_of?(self.class) and identifier == other.identifier
  end
end
