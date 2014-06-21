class StupidStoreman
  attr_accessor :dir
  def initialize(dir)
    @dir = dir
  end

  def store!(data)
    FileUtils.mkdir_p(dir)
    raise RuntimeError if File.exist?(filepath)

    File.open(filepath, 'w') do |file|
      file.write MultiJson.dump(data)
    end
  end

  def filepath
    "#{dir}/projects.json"
  end
end