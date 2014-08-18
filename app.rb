require_relative 'gitforms'
require_relative 'fork_and_send_pull_request'

require 'forme'
require 'sinatra'
require 'dotenv'
Dotenv.load

get '/' do
  @aula = Aula.new
  a = Forme.form(@aula, :method => 'POST') do |f|
    f.input :title, :placeholder => :Title
    f.input :year, :placeholder => :Year
    f.input :url, :placeholder => :URL
    f.input :imageUrl, :placeholder => 'Image URL'
    f.input :description, :placeholder => 'Description'
    f.input :tags, :placeholder => 'tag1, tag2, tag3, ..'
    f.input :speakers, :placeholder => 'speaker1, speaker2'
    f.input :location, :placeholder => "Location"
    f.button
  end
  a.to_s
end

post '/' do
  aula = Aula.new(params)
  github = Gitforms::Github.new(system_login, password)

  use_case = ForkAndSendPullRequest.new(aula, github)
  use_case.run("mkaschenko", "mkaschenko.github.io")
end

private

  def system_login
    ENV['GITHUB_LOGIN']
  end

  def password
    ENV['GITHUB_PWD']
  end