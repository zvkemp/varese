require_relative '../../spec_helper'

describe Varese::FIPS::State do
  specify { Varese::FIPS::State.wont_be_nil }
  specify { Varese::FIPS::State.california.must_equal "06" }
  specify { Varese::FIPS::State.ca.must_equal "06" }
  specify { Varese::FIPS::State.oh.must_equal "39" }

  specify { Varese::FIPS::State.abbreviation(:ca).must_equal "06" }
  specify { -> { Varese::FIPS::State.abbreviation(:zk) }.must_raise Varese::FIPS::UnknownAbbreviation }
end
