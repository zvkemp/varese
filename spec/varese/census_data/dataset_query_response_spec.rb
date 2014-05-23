require_relative '../../spec_helper'

describe Varese::CensusData::DatasetQueryResponse do
  let(:klass){ Varese::CensusData::DatasetQueryResponse }

  specify { default_dataset.must_be_instance_of Varese::CensusData::Dataset }

  describe "all counties in california" do
    let(:guids){ ["B01001_021E", "B01001_042E", "B01001_049E", "B01001_004E", "B01001_025E"] }
    let(:counties){ default_dataset.query(get: guids.join(","), for: "county:*", in: "state:06") }
    let(:tracts){ default_dataset.query(get: guids.join(","), for: "tract:*", in: "state:06") }
    specify { counties.must_be_instance_of klass }
    specify { counties.header.must_equal guids + %w[state county] } 
    specify { counties.body.count.must_equal 58 }

    specify { tracts.must_be_instance_of klass }

    it %{automatically adds county metadata to tracts} do
      tracts.header.must_equal guids + %w[state county tract]
    end

    specify { tracts.body.count.must_equal 8057 }
  end
end
