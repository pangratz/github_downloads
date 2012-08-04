require "rest-client"
require "github_api"
require "json"

module GithubDownloads
  class Uploader

    attr_reader :login, :username, :repo, :token

    def initialize(login=nil, username=nil, repo=nil, token=nil, root=Dir.pwd)
      @login    = init_login(login)
      @username = init_username(username)
      @repo     = init_repo(repo)
      @root     = root
      @token    = token || ENV['GH_OAUTH_TOKEN'] || check_token
    end

    def init_login(login=nil)
      login || ENV['GH_LOGIN'] || `git config github.user`.chomp
    end

    def init_username(username=nil)
      username || ENV['GH_USERNAME'] || repo_url[2]
    end

    def init_repo(repo=nil)
      repo || ENV['GH_REPOSITORY'] || repo_url[3]
    end

    def repo_url
      origin = `git config remote.origin.url`.chomp
      origin.match(/github\.com[\/:]((.+?)\/(.+?))(\.git)?$/) || []
    end

    def authorized?
      !!@token
    end

    def token_path
      File.expand_path(".github-upload-token", @root)
    end

    def check_token
      File.exist?(token_path) ? File.open(token_path, "rb").read : nil
    end

    def authorize
      return if authorized?

      require 'cgi'

      puts "There is no file named .github-upload-token in this folder. This file holds the OAuth token needed to communicate with GitHub."
      puts "You will be asked to enter your GitHub password so a new OAuth token will be created."
      print "GitHub Password for #{@login}: "
      system "stty -echo" # disable echoing of entered chars so password is not shown on console
      pw = STDIN.gets.chomp
      system "stty echo" # enable echoing of entered chars
      puts ""

      # check if the user already granted access for Ember.js Uploader by checking the available authorizations
      response = RestClient.get "https://#{CGI.escape(@login)}:#{CGI.escape(pw)}@api.github.com/authorizations"
      JSON.parse(response.to_str).each do |auth|
        if auth["note"] == "GitHub Downloads Gem"
          # user already granted access, so we reuse the existing token
          @token = auth["token"]
        end
      end

      ## we need to create a new token
      unless @token
        payload = {
          :scopes => ["public_repo"],
          :note => "GitHub Downloads Gem",
          :note_url => "https://github.com/pangratz/github_downloads"
        }
        response = RestClient.post "https://#{CGI.escape(@login)}:#{CGI.escape(pw)}@api.github.com/authorizations", payload.to_json, :content_type => :json
        @token = JSON.parse(response.to_str)["token"]
      end

      # finally save the token into .github-upload-token
      File.open(token_path, 'w') {|f| f.write(@token)}
      
      # add entry to .gitignore if not already exists
      gitignore = File.expand_path(".gitignore", @root)
      system "touch #{gitignore}"
      includes = File.open(gitignore).lines.any? { |line| line.chomp == '.github-upload-token' }
      if !includes
        File.open(gitignore, "a") do |f|
          f.puts("\n# .github-upload-token stores OAuth token, used by github_downloads gem")
          f.puts(".github-upload-token")
        end
      end
    end

    def remove_file(filename)
      return false unless authorized?

      gh = Github.new :user => @username, :repo => @repo, :oauth_token => @token

      # remvove previous download with the same name
      gh.repos.downloads.list @username, @repo do |download|
        if filename == download.name
          gh.repos.downloads.delete @username, @repo, download.id
          break
        end
      end
    end

    def upload_file(filename, description, file)
      return false unless authorized?

      remove_file(filename)

      gh = Github.new :user => @username, :repo => @repo, :oauth_token => @token

      # step 1
      hash = gh.repos.downloads.create @username, @repo,
        "name" => filename,
        "size" => File.size(file),
        "description" => description

      # step 2
      gh.repos.downloads.upload hash, file

      return true
    end

  end
end