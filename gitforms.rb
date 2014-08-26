require 'sinatra/base'
require 'virtus'
require 'json'
require 'multi_json'

require 'octokit'

require_relative 'lib/stupid_storeman'
require_relative 'lib/aula'


module Gitforms
  class Github
    def initialize(user)
      @client = user
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
    attr_reader :username, :name, :itself, :token

    def initialize(username, name, token = nil)
      @username, @name, @token = username, name, token
      @itself = Octokit::Repository.new "#{username}/#{name}"
    end

    def url
      if token
        "https://#{token}@github.com/#{username}/#{name}.git"
      else
        "https://github.com/#{username}/#{name}.git"
      end
    end
  end
end