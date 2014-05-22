require_relative '../../spec_helper'

describe Varese::CensusData::VariableMeta do
  let(:guid){ "B02001_006E" }
  let(:raw){ { "label" => "Native Hawaiian and Other Pacific Islander alone", "concept" => "B02001.  Race" } }
  let(:variable_meta){ Varese::CensusData::VariableMeta.new(guid, raw) }

  specify { variable_meta.concept_id.must_equal "B02001" }
end
