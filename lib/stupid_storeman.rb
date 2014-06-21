class StupidStoreman
  attr_reader :dir
  def initialize(dir)
    @dir = dir
  end

  # Public: Duplicate some text an arbitrary number of times.
  #
  # data - Anything, most probabaly Hash.
  #
  # Examples
  #
  #   store!(a: 2, b: 3)
  #   # => true
  #
  # Returns true
  # Raises RuntimeError if destination file alredy exists
  def store!(data)
    FileUtils.mkdir_p(dir)
    raise RuntimeError.new "File '#{filepath}' already exists!" if File.exist?(filepath)

    File.open(filepath, 'w') do |file|
      file.write MultiJson.dump(data)
    end
    true
  end

  def filepath
    "#{dir}/projects.json"
  end
end