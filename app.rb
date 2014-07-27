require_relative 'gitforms'

class Repo
  attr_reader :user, :name

  def initialize(user, name)
    @user, @name = user, name
  end

  def url
    "https://github.com/#{user}/#{name}.git"
  end
end

def run(cmd)
  puts cmd
  `#{cmd}`
end

input = Aula.new(
      title: 'Integrated Tests Are A Scam',
      year: 2014,
      url: "https://vimeo.com/80533536",
      imageUrl: "https://i.vimeocdn.com/video/456490527_1280.jpg",
      description: "Integrated tests are a scam. You’re probably writing 2-5% of the integrated tests you need to test thoroughly. You’re probably duplicating unit tests all over the place. Your integrated tests probably duplicate each other all over the place. When an integrated test fails, who knows what’s broken? Integrated tests probably do you more harm than good. Learn the two-pronged attack that solves the problem: collaboration tests and contract tests.",
      tags: ['Testing'],
      speakers: ['J.B. Rainsberger'],
      location: 'Devtraining'
    )

repo = Octokit::Repository.new "mkaschenko/mkaschenko.github.io"
client = Octokit::Client.new(:login => 'inem', :password => '#####')

data = input.prepare
slug = data.fetch(:key)
client.fork(repo)

run "cd ../repos && github clone inem #{repo.name}"
# run "cd ../repos/#{repo.name} && git checkout -b #{slug}"

storeman = StupidStoreman.new("../repos/#{repo.name}/talks", slug)
storeman.store! data

run "cd ../repos/#{repo.name} && git add . && git commit -m 'added talk \'#{data.fetch(:title)}\'' && git push origin master"
ref = Octokit.ref('inem/mkaschenko.github.io', 'heads/master').object.sha
client.create_pull_request(repo, 'master', ref, "added talk '#{data.fetch(:title)}'", "")
# `github pull-request inem #{repo.name}`
# github create pull-request
