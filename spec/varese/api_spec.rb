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

    describe "filtering datasets" do
      specify { api.dataset(vintage: 2010).name.must_equal "acs5" }
      specify { api.dataset(vintage: 2010).vintage.must_equal 2010 }
      specify { api.datasets(vintage: 2012).count.must_equal 6 }
      specify { api.datasets(vintage: 2012, :profile? => false).map(&:name).must_equal %w[acs1 acs3 acs5] }
    end
  end
end

