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
  aula = Aula.new(params)
  github = Gitforms::Github.new(system_login, password)

  use_case = ForkAndSendPullRequest.new(aula, github)
  use_case.run("mkaschenko", "mkaschenko.github.io")
end

class ForkAndSendPullRequest
  def initialize(source, github)
    @github = github
    @source = source
  end

  def run(repo_owner_name, repo_name)
    repo = Gitforms::Repo.new(repo_owner_name, repo_name)
    fork = Gitforms::Repo.new(system_login, repo.name)

    github.delete_repo fork
    github.fork_repo repo

    ref = change_and_push(repo, fork) do
      source.perform_changes!
    end

    github.create_pull_request(repo, ref, message)
    github.delete_repo fork
  end

  private
  attr_accessor :github, :source

  def message
    source.commit_message
  end

  def change_and_push(repo, fork, path = "#{Dir.tmpdir}/#{repo.name}")
    # prepare directory
    # clone repo

    # generate data
    # generate message

    # commit
    # push

    # return ref

    FileUtils.rm_rf path
    git = Git.clone(repo.url, path)

    git.chdir do
      yield
    end

    git.add(all: true)
    git.commit_all message

    remote = git.add_remote('cloned', fork.url)
    git.push remote

    git.log.first.to_s # returns ref
  end
end

private

  def system_login
    ENV['GITHUB_LOGIN']
  end

  def password
    ENV['GITHUB_PWD']
  end