require_relative '../../spec_helper'

describe Varese::CensusData::ConceptMeta do
  let(:klass){ Varese::CensusData::ConceptMeta }
  let(:concept){ default_dataset.concept("B01001") }


  # the insane number of variables make loading the VariableMetaSet from YAML
  # very slow. Smashing these assertions together into a single test:
  specify "a lot of assertions" do
    -> { default_dataset.concept("MISSING") }.must_raise ArgumentError
    concept.must_be_instance_of klass
    concept.dataset.must_equal default_dataset
  end
end
