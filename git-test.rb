require_relative 'gitforms'
require 'git'
require 'dotenv'
Dotenv.load

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

system_login = ENV['GITHUB_LOGIN']
pwd = ENV['GITHUB_PWD']

repo_url = 'https://github.com/mkaschenko/mkaschenko.github.io.git'

repo = Octokit::Repository.new "mkaschenko/mkaschenko.github.io"
inem_repo = Octokit::Repository.new "#{system_login}/mkaschenko.github.io"

client = Octokit::Client.new(:login => system_login, :password => pwd)
# client = Octokit::Client.new(:access_token => ENV['GITHUB_ACCESS_TOKEN'])
# client.delete_repo inem_repo

data = input.prepare
slug = data.fetch(:key)
client.fork(repo)

FileUtils.rm_rf "#{Dir.tmpdir}/#{repo.name}"

g = Git.clone("#{repo.url}.git", "#{Dir.tmpdir}/#{repo.name}")
g.chdir do
  FileUtils.mkdir_p("./talks/")
  File.open("./talks/#{slug}.json", 'w') do |file|
    file.write JSON.pretty_generate(data)
  end
end

msg = "added talk '#{data.fetch(:title)}'"
g.add(:all=>true)
g.commit_all(msg)

r = g.add_remote('cloned', "https://github.com/#{system_login}/mkaschenko.github.io.git")
g.push(r)
ref = g.log.first.to_s

client.create_pull_request(repo, 'master', ref, "added talk '#{data.fetch(:title)}'", "")
client.delete_repo inem_repo