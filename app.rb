require_relative 'gitforms'
require 'git'
require 'dotenv'
Dotenv.load

require 'forme'
require 'sinatra'

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
  input = Aula.new(params)

  system_login = ENV['GITHUB_LOGIN']
  pwd = ENV['GITHUB_PWD']

  repo_url = 'https://github.com/mkaschenko/mkaschenko.github.io.git'

  repo = Octokit::Repository.new "mkaschenko/mkaschenko.github.io"
  inem_repo = Octokit::Repository.new "#{system_login}/mkaschenko.github.io"

  client = Octokit::Client.new(:login => system_login, :password => pwd)
  # client.delete_repo inem_repo

  data = input.prepare
  slug = data.fetch(:key)
  client.fork(repo)

  FileUtils.rm_rf "#{Dir.tmpdir}/#{repo.name}"

  g = Git.clone("#{repo.url}.git", "#{Dir.tmpdir}/#{repo.name}")
  g.chdir do
    FileUtils.mkdir_p("./talks/")
    File.open("./talks/#{slug}.json", 'w') do |file|
      file.write JSON.pretty_generate(data)
    end
  end

  msg = "added talk '#{data.fetch(:title)}'"
  g.add(:all=>true)
  g.commit_all(msg)

  r = g.add_remote('cloned', "https://github.com/#{system_login}/mkaschenko.github.io.git")
  g.push(r)
  ref = g.log.first.to_s

  client.create_pull_request(repo, 'master', ref, "added talk '#{data.fetch(:title)}'", "")
  client.delete_repo inem_repo
end
