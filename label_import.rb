#! /usr/bin/env ruby

require 'bundler'
require 'yaml'

Bundler.require(:default)
require 'highline/import'

# So evil ಠ_ಠ
HighLine.colorize_strings

class GitHubRepo
  def initialize(path)
    @path = path
  end

  def delete_all_labels
    Octokit.labels(@path).each do |l|
      say "Removing label #{l[:name]} ...".send("rgb_#{l[:color]}")
      Octokit.delete_label!(@path, l[:name])
    end
  end

  def update_label(name, color)
    say "Label '#{name}' found, updating ...".send("rgb_#{color}")
    Octokit.update_label(@path, name, color: color)
  end

  def add_label(name, color)
    say "Label '#{name}' not found, adding ...".send("rgb_#{color}")
    Octokit.add_label(@path, name, color)
  end

  def labels_url
    "https://github.com/#{@path}/labels"
  end
end


def main
  puts
  say "Login using username and password"
  username = ask("Username: ")
  password = ask("Password: ") { |q| q.echo = false }
  say username

  Octokit.configure do |c|
    c.login = username
    c.password = password
  end

  organizations = Octokit.organizations

  org_name = nil
  choose do |menu|
    menu.prompt = "Please choose the organization"

    organizations.each do |org|
      menu.choice(org[:login]) { org_name = org[:login] }
    end
  end

  repositories = Octokit.organization_repositories(org_name, per_page: 100)

  repo_name = nil
  choose do |menu|
    menu.prompt = "Please choose the repository"

    repositories.each do |repo|
      menu.choice(repo[:name]) { repo_name = repo[:name] }
    end
  end


  full_repo_name = "#{org_name}/#{repo_name}"

  repo = GitHubRepo.new(full_repo_name)

  puts
  say "Replace labels for: #{full_repo_name}"
  puts
  say "DANGER ZONE".rgb(255, 0, 0)
  say "By carelessly removing labels of a repository you also remove them"
  say "from all issues and pull requests."
  say "If in doubt, choose the non-destructive 'Synchronize' option."
  puts

  choose do |menu|
    menu.prompt = "Please choose the type of importing you want to do"

    menu.choice("Synchronize: Add new labels and update existing ones")
    menu.choice("Replace: Remove all labels before synchronizing <%= color('DESTRUCTIVE', RED, BOLD) %>") {
      repo.delete_all_labels
    }
  end

  labels = YAML::load_file("default_labels.yml")
  labels.map do |l|
    begin
      Octokit.label(full_repo_name, l[:name])
      repo.update_label(l[:name], l[:color])
    rescue Octokit::NotFound
      repo.add_label(l[:name], l[:color])
    end
  end

  puts
  say "Finished importing labels for #{full_repo_name}."
  say "Check out the labels at #{repo.labels_url}"
end

begin
  main
rescue Interrupt
  say "Exiting..."
end
