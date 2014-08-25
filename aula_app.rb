require_relative 'gitforms'
require_relative 'fork_and_send_pull_request'

require 'rubygems'
require "bundler/setup"
require 'sinatra_auth_github'

require 'sinatra'
require 'dotenv'
Dotenv.load

module Gitforms
  class Aula < Sinatra::Base
    enable :sessions

    set :github_options, {
      :scopes    => "user",
      :secret    => ENV['GITHUB_CLIENT_SECRET'],
      :client_id => ENV['GITHUB_CLIENT_ID'],
    }

    get '/logout' do
      logout!
      redirect 'https://github.com'
    end

    register Sinatra::Auth::Github

    get '/aula.io' do
      haml :aula
    end

    post '/aula.io' do
      authenticate!
      aula = Aula.new(params)
      github = Gitforms::Github.new(github_user)

      use_case = ForkAndSendPullRequest.new(aula, github, github_user.login)
      # use_case.run("hnrc", "aula")
      use_case.run("mkaschenko", "mkaschenko.github.io")
      redirect '/aula.io'
    end
  end
end

