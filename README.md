# Prestashop
[![Build Status][badge-jenkins]][jenkins] [![Issue tracker][badge-jira]][jira] [![Repository][badge-bitbucket]][bitbucket] [![Coverage][badge-simplecov]][simplecov] [![Guide][badge-guide]][guide]  [![Docs][badge-docs]][docs]

Comunicate with Prestashop from Ruby via Prestashop WebService

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prestashop', git: 'git@bitbucket.org:werein/prestashop.git', branch: 'master'
```

## Usage

Connect to your Prestashop WebService
```ruby
Prestashop::Client::Implementation.create 'api_key', 'api_url'
```
Now you are able to communicate with Prestashop WebService

### API

To call API request directly you can use this class, for better handling is recomenden to use `Mapper` class.

###### Head / Check

Call HEAD on WebService API, returns +true+ if was request successfull or raise error, when request failed.

``` ruby
Client.head :customer, 2 # => true
Client.check :customer, 3 # => true
```

###### Get / Read

Call GET on WebService API, returns parsed Prestashop response or raise error, when request failed.

```ruby
Client.get :customer, 1       # => {id: 1 ...}
Client.read :customer, [1,2]  # => [{id: 1}, {id: 2}]
```

**Available options:**

* filter
* display
* sort
* limit
* schema
* date

###### Post / Create
Call POST on WebService API, returns parsed Prestashop response if was request successfull or raise error, when request failed.

```ruby
Client.post :customer, { name: 'Steve' } # => true
```

###### Put / Update

Call PUT on WebService API, returns parsed Prestashop response if was request successfull or raise error, when request failed.

```ruby
Client.put :customer, 1, {surname: 'Jobs'} # => true
Client.update :customer, 1, {nope: 'Jobs'} # => false
```

###### Delete / Destroy

Call DELETE on WebService API, returns +true+ if was request successfull or raise error, when request failed.

```ruby
Client.delete :customer, 1 # => true
```

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