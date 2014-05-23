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
  specify { variable_meta.attributes.must_equal [%{Native Hawaiian and Other Pacific Islander alone}]}

  describe "a multiple attribute variable" do
    let(:guid){ "B01001_042E" }
    let(:raw){ { "label" => "Female:!!60 and 61 years", "concept" => "B01001.  Sex by Age" } }

    specify { variable_meta.concept_id.must_equal "B01001" }
    specify { variable_meta.type.must_equal :estimate }
    specify { variable_meta.attributes.must_equal %w[Female: 60\ and\ 61\ years] }
  end
end
