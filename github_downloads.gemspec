# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'github_downloads/version'

Gem::Specification.new do |s|
  s.name          = "github_downloads"
  s.version       = GithubDownloads::VERSION
  s.authors       = ["Clemens Müller", "Peter Wagenet"]
  s.email         = ["cmueller.418@gmail.com", "peter.wagenet@gmail.com"]
  s.homepage      = "https://github.com/pangratz/github_downloads"
  s.summary       = "Upload files to GitHub Downloads"
  s.description   = "Library to upload files to GitHub Downloads section of a specific repository"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']

  s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "github_api"

  s.add_development_dependency "rake"
end
