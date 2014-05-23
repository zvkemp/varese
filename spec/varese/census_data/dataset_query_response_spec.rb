require_relative '../../spec_helper'

describe Varese::CensusData::DatasetQueryResponse do
  let(:klass){ Varese::CensusData::DatasetQueryResponse }

  specify { default_dataset.must_be_instance_of Varese::CensusData::Dataset }

  describe "all counties in california" do
    let(:guidsa) do
      %w[B01001_001E B01001_001M B01001_002E B01001_002M B01001_003E B01001_003M B01001_004E 
        B01001_004M B01001_005E B01001_005M B01001_006E B01001_006M B01001_007E B01001_007M B01001_008E 
        B01001_008M B01001_009E B01001_009M B01001_010E B01001_010M B01001_011E B01001_011M 
        B01001_012E B01001_012M B01001_013E B01001_013M B01001_014E B01001_014M B01001_015E 
        B01001_015M B01001_016E B01001_016M B01001_017E B01001_017M B01001_018E B01001_018M 
        B01001_019E B01001_019M B01001_020E B01001_020M B01001_021E B01001_021M B01001_022E 
        B01001_022M B01001_023E B01001_023M B01001_024E B01001_024M B01001_025E B01001_025M 
        B01001_026E B01001_026M B01001_027E B01001_027M B01001_028E B01001_028M B01001_029E 
        B01001_029M B01001_030E B01001_030M B01001_031E B01001_031M B01001_032E B01001_032M 
        B01001_033E B01001_033M B01001_034E B01001_034M B01001_035E B01001_035M B01001_036E 
        B01001_036M B01001_037E B01001_037M B01001_038E B01001_038M B01001_039E B01001_039M 
        B01001_040E B01001_040M B01001_041E B01001_041M B01001_042E B01001_042M B01001_043E 
        B01001_043M B01001_044E B01001_044M B01001_045E B01001_045M B01001_046E B01001_046M 
        B01001_047E B01001_047M B01001_048E B01001_048M B01001_049E B01001_049M
      ]
    end

    specify { puts guidsa.count }

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


    describe "to_a" do
      let(:variable_metadata){ guids.map {|g| [g, default_dataset.variables.by_guid[g]] } }
      let(:counties_array){ counties.to_a }
      specify { counties_array.first.must_equal 1 }
      specify { puts variable_metadata.inspect }
    end
  end
end
