[![Code Climate](https://codeclimate.com/github/zvkemp/varese.png)](https://codeclimate.com/github/zvkemp/varese)

# Varese

### A Ruby interface to the US Census API.

**This is currently an early-stage project and is not ready for production.** Contributions welcome.

This product uses the [Census Bureau Data API](http://www.census.gov/developers/) but is not endorsed or certified by the Census Bureau.

#### Varese?

Yes: [http://en.wikipedia.org/wiki/Am%C3%A9riques](http://en.wikipedia.org/wiki/Am%C3%A9riques)

## Installation

Add this line to your application's Gemfile:

    gem 'varese', git: 'https://github.com/zvkemp/varese.git'

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


#### scrap / examples

```ruby
dataset    = Varese::API.new.dataset(name: "acs5", vintage: 2012)
sex_by_age = dataset.concept("B01001")
data       = sex_by_age.raw_data(:for => "county:*", :in => "state:06")
```

**Please Note:** I am currently testing with the American Community Survey 5-year 2012 dataset.
The formats of other datasets are **not consistent** and are not currently supported (however, they
may work anyway! Give it a shot).

##### Combining a multi-variable concept into a single variable

Example: B01001, Sex by Age, all counties in California

```ruby
# continuing from previous example...

# Note: the below process should be considerably improved.
# To combine male & female results into a single set (still split by age),
# map the desired attributes to a hash, grabbing the second attribute (age) only:
attr_map = sex_by_age.variables.each_with_object({}) do |variable, hash|
  hash[variable.guid] = variable.attributes[1] if variable.attributes[1]
end

# => {
# "B01001_003E"=>"Under 5 years", 
# "B01001_003M"=>"Under 5 years", 
# "B01001_004E"=>"5 to 9 years", 
# "B01001_004M"=>"5 to 9 years", 
# "B01001_005E"=>"10 to 14 years", 
# "B01001_005M"=>"10 to 14 years", 
# "B01001_006E"=>"15 to 17 years" ...

data.group_by_attributes(attr_map)
# => { { "state" => "06", "county" => "001" } => { "Under 5 years" => 2048 ... } ...}
```

`nil` values will be skipped. If no mapping hash is given, it will simply map to the original
keys (eg "B001001_003E").

The values for this attributes hash can also be arrays, in which case the grouping generated
will be a nested hash. For example:

```ruby
attr_map = sex_by_age.variables.each_with_object({}) do |variable, hash|
  hash[variable.guid] = variable.attributes[0..1] 
end.select {|_, v| v.count == 2 }
# currently, all attribute arrays need to be the same length.

data.group_by_attributes(attr_map) 
# => { { "state" => "06", "county" => "001" } => { "Male" => { "Under 5 years" => 1023 }} ... }
```





## Contributing

1. Fork it ( http://github.com/zvkemp/varese/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
