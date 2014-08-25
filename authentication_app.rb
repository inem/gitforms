require 'sinatra'
require "rubygems"
require "bundler/setup"
require 'sinatra_auth_github'

module Gitforms
  class Authentication < Sinatra::Base
    enable :sessions

    set :github_options, {
      :scopes    => "user",
      :secret    => ENV['GITHUB_CLIENT_SECRET'],
      :client_id => ENV['GITHUB_CLIENT_ID'],
    }

    register Sinatra::Auth::Github

    helpers do
      def repos
        github_request("user/repos")
      end
    end

    get '/' do
      authenticate!
      "Hello there, #{github_user.login}!"
    end

    get '/logout' do
      logout!
      redirect 'https://github.com'
    end
  end
end