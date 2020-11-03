# MultiPassword

MultiPassword provides a generic interface for popular password hashing algorithm,
so that user can easily switch between different algorithms without worrying
about changing application code in multiple places.

MultiPassword also supports running multiple algorithms in one application, which is
great when you want to migrate from one algorithm to another.

Currently MultiPassword supports 3 algorithms:

- SCrypt
- BCrypt
- Argon2

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'multi_password'

# if you want to use scrypt, you need to include the gem manually:
gem 'scrypt'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install multi_password

## Usage

### Configuration

You can specify an application-wide default algorithm:

```ruby
# require the strategy you want to use here
require 'multi_password/strategies/scrypt'

MultiPassword.configure do |config|
  config.default_algorithm = :scrypt

  # support all options that SCrypt accepts
  config.default_options = { key_len: 64, max_time: 1 }
end
```

You can also specify algorithm and options on-the-fly:

```ruby
manager = MultiPassword.new(algorithm: :scrypt, options: { key_len: 64, max_time: 1 })
```

### Interface

MultiPassword provides 2 methods: `create` for hashing password and `verify` for
verifying input password:

```ruby
require 'multi_password/strategies/scrypt'

manager = MultiPassword.new(algorithm: :scrypt)

encrypted_password = manager.create('password')
# => "4000$8$2$df55d1c7bc475c6d4a7db9dac5c4d0469121419355f54c4ae23f61556f7198ac$2933bd4ed4b1d902951babe856aeb160ef3f061d7927ed46c749036b1edea509"

manager.verify('password', encrypted_password)
# => true
```

###

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/multi_password.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
