require_relative 'gitforms'
require_relative 'fork_and_send_pull_request'

require 'rubygems'
require "bundler/setup"

require 'sinatra'
require 'dotenv'
Dotenv.load

module Gitforms
  class Aula < Sinatra::Base

    get '/' do
      haml :aula
    end

    post '/' do
      aula = Aula.new(params)
      github = Gitforms::Github.new(system_login, password)

      use_case = ForkAndSendPullRequest.new(aula, github)
      # use_case.run("hnrc", "aula")
      use_case.run("mkaschenko", "mkaschenko.github.io")
      redirect '/'
    end

    private

    def system_login
      ENV['GITHUB_LOGIN']
    end

    def password
      ENV['GITHUB_PWD']
    end
  end
end

