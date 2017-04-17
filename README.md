# DaisyChain

DaisyChain builds on the work for [`Interactor`](https://github.com/collectiveidea/interactor),
[`Troupe`](https://github.com/jonstokes/troupe) and
[`Interactor Schema`](https://github.com/berfarah/interactor-schem://github.com/berfarah/interactor-schema)
to create a chain of services that have a less mutable context. The idea here is
that you should pass things around sparingly. Furthermore, each context can be
suited to the task at hand like an adapter, and can inherit properties from
other adapters.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'daisy_chain'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install daisy

## Usage

See [here](https://github.com/collectiveidea/interactor) for the official
Interactor documentation.

The way `DaisyChain` in particular works is that it forces a though-out context
from the start.

```rb
class UserContext
  attributes :name, :email

  def first_name
    name.split(" ").first
  end
end

class SaveUser
  include DaisyChain
  requires(:first_name, :email)
  context UserContext

  def call
    Mailer.welcome_email(email: email, name: first_name).deliver_later
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/daisy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

