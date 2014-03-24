require_relative '../spec_helper'

describe Varese::URLBuilder do


  [
    [{ acs: 5, year: 2012 }, 'http://api.census.gov/data/2012/acs5'],
    [{ acs: 1, year: 2010 }, 'http://api.census.gov/data/2010/acs1'],
    [{ sf: 1, year: 2010 }, 'http://api.census.gov/data/2010/sf1']
  ].each do |options, expectation, description|
    specify description do 
      builder = Varese::URLBuilder.new(options)
      builder.to_str.must_equal expectation
    end
  end

end
