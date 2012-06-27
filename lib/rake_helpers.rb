module RakeHelpers
  def parse_path(path=nil)
    if path.nil?
      raise ArgumentError, "Path not specified"

    elsif File.file?(path)
      Array(path)

    elsif File.directory?(path)
      Dir.entries.map do |entry|
        File.join(path,entry)
      end.select do |entry_path|
        File.file?(entroy_path)
      end

    else
      raise IOError, "File not found"
    end
  end
end
