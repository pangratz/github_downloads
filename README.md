# github_downloads

Simple library to upload files to GitHub repository.

## Sample usage

Provide login, username and repository:

```ruby
require 'github_downloads'

uploader = GithubDownloads::Uploader.new
uploader.initialize(login, username, repository, token)
```

You can also let the library use the login, username and repository of the .git repository of the project:

```ruby
uploader = GithubDownloads::Uploader.new
uploader.initialize
```

Or you can define the login, username, repository and token via `ENV`:

```ruby
ENV['GH_LOGIN'] = "my-login"
ENV['GH_USERNAME'] = "my-username"
ENV['GH_REPOSITORY'] = "my-repo"
ENV['GH_OAUTH_TOKEN'] = "12345"

uploader = GithubDownloads::Uploader.new
uploader.initialize
```
