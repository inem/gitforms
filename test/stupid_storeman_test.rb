require_relative 'test_helper'
require 'multi_json'

class StupidStoremanTest < MiniTest::Unit::TestCase
  def setup
    FakeFS.activate!
    FileUtils.mkdir_p("/Users/#{ENV['USER']}") # for pry under fakefs
  end

  def teardown
    FakeFS.deactivate!
  end


  def test_storeman
    data = { name: 'aaa/bbb', tags: 'a, b, c' }

    storeman = StupidStoreman.new(stuff_directory)
    storeman.store!(data)

    assert_raises RuntimeError do
      storeman.store!('blah')
    end

    read_json = MultiJson.load File.open(storeman.filepath).read
    data_json = MultiJson.load(MultiJson.dump(data))

    assert_equal read_json, data_json
  end


  def stuff_directory
    Dir.tmpdir
  end
end