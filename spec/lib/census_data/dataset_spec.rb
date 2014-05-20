require_relative '../../spec_helper'

describe Varese::CensusData::Dataset do
  specify { Varese::CensusData::Dataset.wont_be_nil }
  let(:api){ Varese::API.new(Varese::MockAccessToken.new) }

  describe "acs5 2010" do
    let(:raw_data){ api.send(:raw_datasets).first }
    let(:dataset){ Varese::CensusData::Dataset.new(raw_data, api) }
    specify { raw_data.must_be_instance_of Hash }

    describe "methods" do
      specify { dataset.vintage.must_equal 2010 }
      specify { dataset.name.must_equal "acs5" }
      specify { dataset.link(:geography).must_equal "http://api.census.gov/data/2010/acs5/geography.json" }
      specify { dataset.link(:variables).must_equal "http://api.census.gov/data/2010/acs5/variables.json" }
      specify { dataset.link(:tags).must_equal "http://api.census.gov/data/2010/acs5/tags.json" }
      specify { dataset.link(:documentation).must_equal "http://www.census.gov/developers/" }
      specify { dataset.must_be :aggregate? }
      specify { dataset.description.must_equal raw_data["description"] }
      specify { dataset.identifier.must_equal "2010acs5" }
      specify { dataset.spatial.must_equal "US" }
      specify { dataset.temporal.must_equal 2010 }
    end

    describe "meta" do
      specify { dataset.geography.must_be_instance_of Varese::CensusData::GeographyMeta   }
      specify { dataset.variables.must_be_instance_of Varese::CensusData::VariableMetaSet }

      specify "searching" do
        age = dataset.variables.search_labels('age')
        age.must_be_instance_of Array
      end
      # specify { dataset.variables.search('age').must_be_instance_of Array }
    end
  end

  describe "acs5 2012" do
    let(:dataset){ api.datasets.find {|ds| ds.identifier == "2012acs5" }}
    specify { dataset.must_be_instance_of Varese::CensusData::Dataset }
    specify { dataset.variables.must_be_instance_of Varese::CensusData::VariableMetaSet }
  end 
end
