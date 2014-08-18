class Aula
  include Virtus.model

  attribute :title, String
  attribute :year, Integer
  attribute :url, String
  attribute :imageUrl, String
  attribute :description, String
  attribute :tags, Array[String]
  attribute :speakers, Array[String]
  attribute :location, String

  def prepared_data
    @hash ||= wrap_and_keyize(title).merge({
      year: year,
      url: url,
      imageUrl: imageUrl,
      description: description,
      tags: tags.map{|t| wrap_and_keyize(t)},
      speakers: speakers.map{ |t| wrap_and_keyize(t) },
      location: wrap_and_keyize(location),
      added: Time.now.utc
    })
  end

  def perform_changes!
    FileUtils.mkdir_p "./talks/"
    File.open("./talks/#{slug}.json", 'w') do |file|
      file.write JSON.pretty_generate(prepared_data)
    end
  end

  def commit_message
    "added talk '#{title}'"
  end

  private
  def slug
    keyize(title)
  end
end

def wrap_and_keyize(value)
  {
    title: value,
    key: keyize(value)
  }
end

def keyize(value)
  value
    .strip
    .downcase
    .tr_s('^A-Za-z0-9', '-')
end