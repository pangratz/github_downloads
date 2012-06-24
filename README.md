# github_downloads

Simple library to upload files to GitHub repository. It authenticates via OAuth token to GitHub. The token itself will be stored in the file `.github-upload-token` in the root directory of the project.

## Usage

The library needs the following settings so it can upload files to a specific GitHub repository:

- **login** : your GitHub username
- **username** : the username of the GitHub repository, to which the file shall be uploaded. May be the same as login but if you upload a file to a repository of an organization, it's the organizations' name
- **repo** : the name of the repository
- **token** : the OAuth token needed to authenticate to GitHub

There are several ways to provide this information to the library.

You can set the login, username, repo and oauth token when you instantiate the library:

```ruby
uploader = GithubDownloads::Uploader.new(login, username, repository, token)
```

You can also let the library use the login, username and repository of the .git repository of the project in which you are using this library. This works basically by getting the values from git config. So the `login` is retrieved via `git config github.user` and the `username` and `repo` are extracted from `git config remote.origin.url`:

```ruby
uploader = GithubDownloads::Uploader.new
```

You can also define the login, username, repository and token via `ENV`:

```ruby
ENV['GH_LOGIN'] = "pangratz"
ENV['GH_USERNAME'] = "pangratz"
ENV['GH_REPOSITORY'] = "github_downloads"
ENV['GH_OAUTH_TOKEN'] = "12345"

uploader = GithubDownloads::Uploader.new
```
If you don't have an OAuth token yet, you can use the `authorize` method of the `Uploader`:

```ruby
uploader = GithubDownloads::Uploader.new
uploader.authorize
```

The `authorize` checks if there is a file named `.github-upload-token`. If so, it uses the OAuth token which is stored in this file. If there is no such file, the library will ask you to enter the GitHub password. Then GitHub is contacted via its API and an OAuth token is retrieved which is then stored in the `.github-upload-token` for further usage. 

If you want to revoke the access of this library, simply revoke the access to the created application `GitHub Downloads Gem (API)` on https://github.com/settings/applications

If you don't trust this authorize method, you can create one yourself as described in http://developer.github.com/v3/oauth/#create-a-new-authorization