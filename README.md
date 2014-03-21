# Prestashop
[![Build Status][badge-jenkins]][jenkins] [![Issue tracker][badge-jira]][jira] [![Repository][badge-bitbucket]][bitbucket] [![Coverage][badge-simplecov]][simplecov] [![Guide][badge-guide]][guide]  [![Docs][badge-docs]][docs]

Comunicate with Prestashop from Ruby via Prestashop WebService

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prestashop'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prestashop

## Usage

Connect to your Prestashop WebService
```ruby
Prestashop::Client::Implementation.create 'api_key', 'api_url'
```
Now you are able to find, create, update or delete.

### API

TODO

### Mapper

TODO

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[badge-jenkins]: http://jenkins.werein.cz/buildStatus/icon?job=prestashop
[badge-jira]: http://img.shields.io/badge/Issues-JIRA-blue.svg
[badge-bitbucket]: http://img.shields.io/badge/Repo-BitBucket-blue.svg
[badge-simplecov]: http://img.shields.io/badge/Coverage-SimpleCov-brightgreen.svg
[badge-guide]: http://img.shields.io/badge/Read-Guide-orange.svg
[badge-docs]: http://img.shields.io/badge/Read-Docs-lightgrey.svg

[jenkins]: http://jenkins.werein.cz/view/gems/job/prestashop
[jira]: http://jira.werein.cz/browse/PS
[bitbucket]: https://bitbucket.org/werein/prestashop
[simplecov]: http://jenkins.werein.cz/view/gems/job/prestashop/ws/coverage/index.html#_AllFiles
[guide]: http://werein.github.io/private-gems/prestashop/
[docs]: http://jenkins.werein.cz/view/gems/job/prestashop/ws/doc/index.html