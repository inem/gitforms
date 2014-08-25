require 'sinatra/base'
require 'virtus'
require 'json'
require 'multi_json'

require 'octokit'

require_relative 'lib/stupid_storeman'
require_relative 'lib/aula'
require_relative 'lib/apply_changes'
require_relative 'lib/author'


module Gitforms
  class Github
    def initialize(username, password)
      @client = Octokit::Client.new(:login => username, :password => password)
    end

    def delete_repo(repo)
      client.delete_repo repo.itself
    end

    def fork_repo(repo)
      client.fork repo.itself
    end

    def create_pull_request(repo, ref, message, branch = 'master')
      sleep 90
      client.create_pull_request(repo.itself, branch, ref, message, "")
    end

    private
    attr_reader :client
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