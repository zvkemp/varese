require_relative '../../spec_helper'

describe Varese::CensusData::VariableMeta do
  let(:klass){ Varese::CensusData::VariableMeta }
  let(:guid){ "B02001_006E" }
  let(:raw){ { "label" => "Native Hawaiian and Other Pacific Islander alone", "concept" => "B02001.  Race" } }
  let(:variable_meta){ klass.new(guid, raw) }

  specify { variable_meta.concept_id.must_equal "B02001" }
  specify { variable_meta.type.must_equal :estimate }
  specify { klass.new("B02001_006M", {}).type.must_equal :margin_of_error }
  specify { klass.new("B02001_006U", {}).type.must_equal :unknown }
end
