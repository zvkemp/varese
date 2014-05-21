# Varese

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'varese'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install varese

## Usage

* This is a very rough draft *

By default, Varese will look for a `fixtures/api_key` file (ignored by git). An API key from the census can also be
passed to the `AccessToken` constructor:

```ruby
# using defaults
api = Varese::API.new

# passing in a key
api = Varese::API.new(Varese::AccessToken.new("api_key"))
```




## Contributing

1. Fork it ( http://github.com/<my-github-username>/varese/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

