# Varese

### A Ruby interface to the US Census API.

**This is currently an early-stage project and is not ready for production.** Contributions welcome.

This product uses the [Census Bureau Data API](http://www.census.gov/developers/) but is not endorsed or certified by the Census Bureau.

#### Varese?

Yes: [http://en.wikipedia.org/wiki/Am%C3%A9riques](http://en.wikipedia.org/wiki/Am%C3%A9riques)

## Installation

Add this line to your application's Gemfile:

    gem 'varese', git: https://github.com/zvkemp/varese.git

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install varese

## Usage

By default, Varese will look for a `fixtures/api_key` file (ignored by git). An API key from the census can also be
passed to the `AccessToken` constructor:

```ruby
# using defaults
api = Varese::API.new

# passing in a key
api = Varese::API.new(Varese::AccessToken.new("api_key"))
```


scrap / examples

```ruby
dataset    = Varese::API.new.dataset(name: "acs5", vintage: 2012)
sex_by_age = dataset.concept("B01001")
data       = sex_by_age.raw_data(:for => "county:*", :in => "state:06")
```



## Contributing

1. Fork it ( http://github.com/<my-github-username>/varese/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
