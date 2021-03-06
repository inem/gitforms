require_relative 'gitforms'
require_relative 'fork_and_send_pull_request'

require 'rubygems'
require "bundler/setup"
require 'sinatra_auth_github'

require 'sinatra'
require 'dotenv'
Dotenv.load

module Gitforms
  class AulaApp < Sinatra::Base
    enable :sessions

    set :github_options, {
      :scopes    => "user public_repo delete_repo",
      :secret    => ENV['GITHUB_CLIENT_SECRET'],
      :client_id => ENV['GITHUB_CLIENT_ID'],
    }

    get '/logout' do
      logout!
      redirect 'https://github.com'
    end

    register Sinatra::Auth::Github

    get '/aula.io' do
      authenticate!
      haml :aula
    end

    post '/aula.io' do
      authenticate!
      aula = Aula.new(params)
      github = Gitforms::Github.new(github_user.api)

      use_case = ForkAndSendPullRequest.new(aula, github)
      # use_case.run("hnrc", "aula")
      use_case.run("mkaschenko", "mkaschenko.github.io", github_user.login, github_user.token)
      redirect '/aula.io'
    end
  end
end

