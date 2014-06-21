ENV['RACK_ENV'] = 'test'

require 'bundler/setup'
require 'minitest/autorun'
require 'fakefs/safe'

require_relative 'app'

class StupidStoremanTest < MiniTest::Unit::TestCase
  def stuff_directory
    Dir.tmpdir
  end

  def setup
    FakeFS.activate!
    # FileUtils.mkdir_p('/Users/inem/') # for pry
  end

  def teardown
    FakeFS.deactivate!
  end

  def test_storeman
    data = {name: 'aaa/bbb', tags: 'a, b, c'}

    storeman = StupidStoreman.new(stuff_directory)
    storeman.store!(data)

    assert_raises RuntimeError do
      storeman.store!('blah')
    end

    read_json = MultiJson.load File.open(storeman.filepath).read
    data_json = MultiJson.load(MultiJson.dump(data))

    assert_equal read_json, data_json
  end
end