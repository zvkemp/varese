require_relative '../spec_helper'

describe Varese::API do
  specify { Varese::API.wont_be_nil }
  specify { Varese::AccessToken.wont_be_nil }
  

  specify "test json response" do
    api = Varese::API.new(Varese::MockAccessToken.new, { acs: 5, year: 2012 })
    response = api.get
  end

  describe "datasets" do
    let(:api){ Varese::API.new(Varese::MockAccessToken.new) }
    let(:datasets){ api.datasets }

    specify { datasets.must_be_instance_of Array }
    specify { datasets.each {|ds| ds.must_be_instance_of Varese::CensusData::Dataset }}
  end
end

