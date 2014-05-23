require_relative '../../spec_helper'

describe Varese::CensusData::Dataset do
  specify { Varese::CensusData::Dataset.wont_be_nil }
  let(:api){ Varese::API.new(Varese::MockAccessToken.new) }

  describe "acs5 2012" do
    let(:dataset){ api.dataset(vintage: 2012, name: "acs5") }


    describe "methods" do
      specify { dataset.vintage.must_equal 2012 }
      specify { dataset.name.must_equal "acs5" }
      specify { dataset.link(:geography).must_equal "http://api.census.gov/data/2012/acs5/geography.json" }
      specify { dataset.link(:variables).must_equal "http://api.census.gov/data/2012/acs5/variables.json" }
      specify { dataset.link(:tags).must_equal "http://api.census.gov/data/2012/acs5/tags.json" }
      specify { dataset.link(:documentation).must_equal "http://www.census.gov/developers/" }
      specify { dataset.must_be :aggregate? }
      specify { dataset.description.must_equal dataset.meta.raw["description"] }
      specify { dataset.identifier.must_equal "2012acs5" }
      specify { dataset.spatial.must_equal "US" }
      specify { dataset.temporal.must_equal 2012 }
      specify { dataset.send(:default_query_options).must_equal({ dataset: "acs5", year: 2012 }) }
      specify do
        dataset.links.tap do |links|
          links.must_be_instance_of Hash
          links.size.must_equal 5
        end
      end
    end

    describe "meta" do
      specify { dataset.geography.must_be_instance_of Varese::CensusData::GeographyMeta   }

      # FIXME: this is really slow (VCR deserializing ~ 150000 lines of yaml)
      # specify { dataset.variables.must_be_instance_of Varese::CensusData::VariableMetaSet }

      # FIXME: also really slow
      #specify "searching" do
        #age = dataset.variables.search_labels('age')
        #age.must_be_instance_of Array
      #end
      # specify { dataset.variables.search('age').must_be_instance_of Array }
    end

    describe "retrieving data by geography" do
      specify do
        dataset.raw_query({ get: "B01001_001E", for: "county:*", in: "state:06"} ).tap do |raw|
          raw.must_be_instance_of Array
        end
      end
    end
  end

end
