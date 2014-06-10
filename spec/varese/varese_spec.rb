require_relative '../spec_helper'

describe Varese do
  specify { Varese::VERSION.wont_be_nil }
  specify { Varese::Datasets.must_be_instance_of Module }
  specify { Varese::Datasets::ACS.must_be_instance_of Hash }
  specify { Varese::Datasets::CENSUS_SUMMARY.must_be_instance_of Hash }
end
