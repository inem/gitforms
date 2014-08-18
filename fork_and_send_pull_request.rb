require 'git'

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

  # prepare directory & clone repo
  # yield (perform some operations on file system)
  # commit & push
  # return ref
  def change_and_push(repo, fork, path = "#{Dir.tmpdir}/#{repo.name}-#{rand(9999999)}")
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