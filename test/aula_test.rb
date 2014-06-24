require_relative 'test_helper'

class AulaTest < MiniTest::Unit::TestCase
  def setup
    input = AulaInput.new(
      title: 'Integrated Tests Are A Scam',
      year: 2014,
      url: "https://vimeo.com/80533536",
      imageUrl: "https://i.vimeocdn.com/video/456490527_1280.jpg",
      description: "Integrated tests are a scam. You’re probably writing 2-5% of the integrated tests you need to test thoroughly. You’re probably duplicating unit tests all over the place. Your integrated tests probably duplicate each other all over the place. When an integrated test fails, who knows what’s broken? Integrated tests probably do you more harm than good. Learn the two-pronged attack that solves the problem: collaboration tests and contract tests.",
      tags: ['Testing'],
      speakers: ['J.B. Rainsberger'],
      location: 'Devtraining'
    )
    @generated_json = input.prepare
    @ideal_json = File.read('test/fixtures/integrated-tests-are-a-scam.json')
  end

  # Not sure if there's much sence in writing such trivial tests
  # def test_correctness
  #   generated_data = JSON.parse(@generated_json)
  #   ideal_data = JSON.parse(@ideal_json)

  #   # [title, url, year, imageUrl]
  #   # assert_equal generated_data.fetch('title'), ideal_data.fetch('title')
  #   # assert_equal generated_data.fetch('url'), ideal_data.fetch('url')
  #   # assert_equal generated_data.fetch('title'), ideal_data.fetch('title')
  #   # assert_equal generated_data.fetch('title'), ideal_data.fetch('title')
  #   # assert_equal generated_data.fetch('title'), ideal_data.fetch('title')
  # end

  # def test_formatting
  #   # ideal = File.read('test/fixtures/integrated-tests-are-a-scam.json')

  #   assert_equal @generated_json, @ideal_json
  # end

  def test_keyize
    assert_equal keyize('J.B. Rainsberger'), 'j-b-rainsberger'
  end
end