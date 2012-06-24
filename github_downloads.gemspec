# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'github_downloads/version'

Gem::Specification.new do |s|
  s.name          = "github_downloads"
  s.version       = GithubDownloads::VERSION
  s.authors       = ["Clemens Müller"]
  s.email         = ["cmueller.418@gmail.com"]
  s.homepage      = "https://github.com/pangratz/github_downloads"
  s.summary       = "TODO: summary"
  s.description   = "TODO: description"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'

  s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "github_api"

  s.add_development_dependency "rake"
end
