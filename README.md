# Prestashop
[![Build Status][travis-badge]][travis] [![Code Climate][code-climate-badge]][code-climate] [![Test coverage][coverage-badge]][coverage] [![Gem Version][version-badge]][version] [![Dependency Status][dependencies-badge]][dependencies] 

Prestashop API for Ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prestashop', github: 'werein/prestashop'
```

Use `branch: 'master'` for local repository in case of bundler global config

## Usage

Create new client for connect to your Prestashop WebService

```ruby
Prestashop::Client::Implementation.create 'api_key', 'api_url'
```

Now you are able to communicate with Prestashop WebService

### API

To call API request directly you can use this class.

###### Head / Check

Call HEAD on WebService API, returns +true+ if was request successfull or raise error, when request failed.

``` ruby
Prestashop::Client.head :customer, 2 # => true
Prestashop::Client.check :customer, 3 # => true
```

###### Get / Read

Call GET on WebService API, returns parsed Prestashop response or raise error, when request failed.

```ruby
Prestashop::Client.get :customer, 1       # => {id: 1 ...}
Prestashop::Client.read :customer, [1,2]  # => [{id: 1}, {id: 2}]
```

When you are using get, you can also filter, sort or limit response. In case, when you need to get all users you need to set user id as `nil`

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
Prestashop::Client.post :customer, { name: 'Steve' } # => true
```

###### Put / Update

Call PUT on WebService API, returns parsed Prestashop response if was request successfull or raise error, when request failed.

```ruby
Prestashop::Client.put :customer, 1, {surname: 'Jobs'} # => true
Prestashop::Client.update :customer, 1, {nope: 'Jobs'} # => false
```

###### Delete / Destroy

Call DELETE on WebService API, returns +true+ if was request successfull or raise error, when request failed.

```ruby
Prestashop::Client.delete :customer, 1 # => true
```

### Mapper

For better handling with Prestashop is there Mapper class, that will map all Prestashop features to Ruby classes.

List of objects can be found on gem docs.

#### Base methods used in every model


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[travis]: https://travis-ci.org/werein/prestashop
[travis-badge]: https://travis-ci.org/werein/prestashop.svg
[code-climate]: https://codeclimate.com/github/werein/prestashop
[code-climate-badge]: https://codeclimate.com/github/werein/prestashop/badges/gpa.svg
[coverage]: https://codeclimate.com/github/werein/prestashop
[coverage-badge]: https://codeclimate.com/github/werein/prestashop/badges/coverage.svg
[version]: http://badge.fury.io/rb/prestashop
[version-badge]: https://badge.fury.io/rb/prestashop.svg
[dependencies]: https://gemnasium.com/werein/prestashop
[dependencies-badge]: ttps://gemnasium.com/werein/prestashop.svg