require 'test/unit'
require 'github_downloads'

class GithubDownloadsTest < Test::Unit::TestCase
  def teardown
    ENV.clear
  end
  
  def test_lookup_env
    ENV['GH_LOGIN'] = "my-login"
    ENV['GH_USERNAME'] = "my-username"
    ENV['GH_REPOSITORY'] = "my-repo"
    ENV['GH_OAUTH_TOKEN'] = "12345"
    uploader = GithubDownloads::Uploader.new

    assert_equal "my-login", uploader.login
    assert_equal "my-username", uploader.username
    assert_equal "my-repo", uploader.repo
    assert_equal "12345", uploader.token
  end

  def test_authorize
    uploader = GithubDownloads::Uploader.new
    uploader.authorize
  end

  def test_upload
    uploader = GithubDownloads::Uploader.new
    uploader.authorize
    uploader.upload_file("LICENSE", "license of this repo", "LICENSE")
  end
end