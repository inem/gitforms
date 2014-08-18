require_relative 'gitforms'
require 'git'
require 'dotenv'
Dotenv.load

require 'forme'
require 'sinatra'


module Gitforms
  class Github
    def initialize(username, password)
      @client = Octokit::Client.new(:login => username, :password => password)
    end

    def delete_repo(repo)
      @client.delete_repo repo.itself
    end

    def fork_repo(repo)
      @client.fork repo.itself
    end

    def create_pull_request(repo, ref, message, branch = 'master')
      @client.create_pull_request(repo.itself, branch, ref, message, "")
    end
  end

  class Repo
    attr_reader :username, :name, :itself

    def initialize(username, name)
      @username, @name = username, name
      @itself = Octokit::Repository.new "#{username}/#{name}"
    end

    def url
      "https://github.com/#{username}/#{name}.git"
    end
  end
end

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

  repo = Gitforms::Repo.new("mkaschenko", "mkaschenko.github.io")
  github = Gitforms::Github.new(system_login, password)

  repo_clone = Gitforms::Repo.new(system_login, repo.name)
  github.delete_repo repo_clone

  data = input.prepare
  slug = data.fetch(:key)

  github.fork_repo repo

  FileUtils.rm_rf "#{Dir.tmpdir}/#{repo.name}"

  git = Git.clone(repo.url, "#{Dir.tmpdir}/#{repo.name}")
  git.chdir do
    FileUtils.mkdir_p("./talks/")
    File.open("./talks/#{slug}.json", 'w') do |file|
      file.write JSON.pretty_generate(data)
    end
  end

  msg = "added talk '#{data.fetch(:title)}'"
  git.add(all: true)
  git.commit_all msg

  r = git.add_remote('cloned', repo_clone.url)
  git.push(r)
  ref = git.log.first.to_s

  github.create_pull_request(repo, ref, msg)
  github.delete_repo repo_clone
end



private

  def system_login
    ENV['GITHUB_LOGIN']
  end

  def password
    ENV['GITHUB_PWD']
  end