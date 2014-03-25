require_relative '../spec_helper'

describe Varese::API do
  specify { Varese::API.wont_be_nil }
  specify { Varese::AccessToken.wont_be_nil }
  

  specify "test json response" do
    api = Varese::API.new(Varese::MockAccessToken.new, { acs: 5, year: 2012 })
    response = api.get
    puts response.inspect
  end

  specify "test 2" do
    api = Varese::API.new(Varese::MockAccessToken.new, { acs: 5, year: 2012, query: { get: "DP02_0001PE", for: "state:*" }})
    response = api.get
    puts response.inspect
  end
end

