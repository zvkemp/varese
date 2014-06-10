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
      specify { counties_array.first.must_be_instance_of Hash }
    end

    describe "group_by_attributes" do
      let(:sex_by_age){ default_dataset.concept("B01001") }
      let(:counties){ sex_by_age.raw_data({ :for => "county:*", :in => "state:06" }) }

      let(:attribute_map) do
        Hash[
          guidsa.map {|guid| 
            [guid, default_dataset.variables.by_guid[guid].attributes]
          }.select {|guid, attrs| attrs.count == 2 } ]
      end

      let(:ages_only) do
        Hash[
          guidsa.map {|guid| 
            [guid, default_dataset.variables.by_guid[guid].attributes[1]]
          }.select {|guid, attr| attr } ]
      end

      let(:reversed_attrs) do
        Hash[
          guidsa.map {|guid|
            [guid, default_dataset.variables.by_guid[guid].attributes.reverse]
          }.select {|guid, attrs| attrs.count == 2 } ]
      end

      let(:grouped){ counties.group_by_attributes(attribute_map) }
      let(:ages){ counties.group_by_attributes(ages_only) }
      let(:reversed){ counties.group_by_attributes(reversed_attrs) }
      let(:county_001){{ "state" => "06", "county" => "001", "tract" => nil }}
      let(:alameda_all){ grouped[county_001] }
      let(:alameda_ages){ ages[county_001] }
      let(:alameda_reversed){ reversed[county_001] }

      specify "the values are summed by attribute" do
        alameda_ages["5 to 9 years"].tap do |pop|
          pop.must_equal(alameda_all["Male:"]["5 to 9 years"] + alameda_all["Female:"]["5 to 9 years"])
          pop.must_equal(alameda_reversed["5 to 9 years"]["Male:"] + alameda_reversed["5 to 9 years"]["Female:"])
        end

        alameda_ages["15 to 17 years"].must_equal(
          alameda_all["Male:"]["15 to 17 years"] +
          alameda_all["Female:"]["15 to 17 years"]
        )
      end
    end
  end
end

describe Varese::CensusData::MergeQueryResponses do
  let(:klass){ Varese::CensusData::MergeQueryResponses }

  let(:raw) do
    [ [ ["VAR_1", "VAR_2", "state", "county"],
        ["100",   "200",   "06"   , "001"   ],
        ["1000",  "2000",  "06"   , "002"   ] ],
      [ ["VAR_3", "VAR_4", "state", "county"],
        ["300",   "400",   "06"   , "001"   ],
        ["3000",  "4000",  "06"   , "002"   ] ],
      [ ["VAR_5", "VAR_6", "state", "county"],
        ["500",   "600",   "06"   , "001"   ],
        ["5000",  "6000",  "06"   , "002"   ] ] ]
  end

  let(:response_1){ Varese::CensusData::DatasetQueryResponse.new(*raw[0]) }
  let(:response_2){ Varese::CensusData::DatasetQueryResponse.new(*raw[1]) }
  let(:response_3){ Varese::CensusData::DatasetQueryResponse.new(*raw[2]) }
  let(:merge){ Varese::CensusData::MergeQueryResponses.new(response_1, response_2, response_3) }
  let(:merged){ merge.to_response }

  specify { merge.send(:common_header_fields).must_equal %w(state county) }
  specify { merge.send(:merged_headers).must_equal %w(VAR_1 VAR_2 VAR_3 VAR_4 VAR_5 VAR_6 state county) }
  specify { merged.body.count.must_equal 2 }
  specify { merged.must_be_instance_of Varese::CensusData::DatasetQueryResponse }
  specify do
    merged.body.first.must_equal %w[100 200 300 400 500 600 06 001]
    merged.body.last.must_equal  %w[1000 2000 3000 4000 5000 6000 06 002]
  end

  describe "group_by_attributes" do
    let(:grouped){ merged.group_by_attributes }
    let(:key){ { "state" => "06", "county" => "001", "tract" => nil } }
    specify { grouped.must_be_instance_of Hash }
    specify { grouped.keys.first.must_equal(key) }
    specify { grouped[key].values_at(*(1..6).map {|n| "VAR_#{n}" }).must_equal((1..6).map {|n| n * 100 }) }

    describe "attributes in original order" do

      let(:attribute_map){{
        "VAR_1" => ["Male", "18 to 24"],
        "VAR_2" => ["Female", "18 to 24"],
        "VAR_3" => ["Male", "25 to 31"],
        "VAR_4" => ["Female", "25 to 31"],
        "VAR_5" => ["Male", "32 to 38"],
        "VAR_6" => ["Female", "32 to 38"]
      }}

      let(:grouped_2){ merged.group_by_attributes(attribute_map) }
      specify { grouped_2.must_be_instance_of Hash }
      specify { grouped_2[key].must_be_instance_of Hash }
      specify { grouped_2[key]["Male"].must_be_instance_of Hash }
      specify { grouped_2[key]["Male"]["18 to 24"].must_equal 100 }
      specify { grouped_2[key]["Female"]["32 to 38"].must_equal 600 }
    end

    describe "attributes in custom order" do
      let(:attribute_map){{
        "VAR_1" => ["18 to 24", "Male"],
        "VAR_2" => ["18 to 24", "Female"],
        "VAR_3" => ["25 to 31", "Male"],
        "VAR_4" => ["25 to 31", "Female"],
        "VAR_5" => ["32 to 38", "Male"],
        "VAR_6" => ["32 to 38", "Female"]
      }}

      let(:grouped_2){ merged.group_by_attributes(attribute_map) }

      specify { grouped_2.must_be_instance_of Hash }
      specify { grouped_2[key].must_be_instance_of Hash }
      specify { grouped_2[key]["18 to 24"]["Male"].must_equal 100 }
      specify { grouped_2[key]["32 to 38"]["Female"].must_equal 600 }

    end
  end
end
