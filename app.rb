require_relative 'gitforms'
require_relative 'fork_and_send_pull_request'

require 'sinatra'
require 'dotenv'
Dotenv.load

get '/aula.io' do
  haml :aula
end

post '/aula.io' do
  aula = Aula.new(params)
  github = Gitforms::Github.new(system_login, password)

  use_case = ForkAndSendPullRequest.new(aula, github)
  # use_case.run("hnrc", "aula")
  use_case.run("mkaschenko", "mkaschenko.github.io")
  redirect '/aula.io'
end

private

  def system_login
    ENV['GITHUB_LOGIN']
  end

  def password
    ENV['GITHUB_PWD']
  end