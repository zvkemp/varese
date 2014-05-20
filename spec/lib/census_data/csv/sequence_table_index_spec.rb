require_relative '../../../spec_helper'

describe Varese::CensusData::CSV::SequenceTableIndex do
  let(:klass){ Varese::CensusData::CSV::SequenceTableIndex }
  specify { klass.wont_be_nil }

  let(:index){ klass.new("fixtures/acs2012_sequence_and_table_lookup.csv") }
  specify { index.must_be_instance_of klass }
  specify { puts index.header.inspect }
  specify do
    index.parsed.to_a.each { |something| puts something.first.inspect }

    puts "-------------------------------"

    puts index.parsed.to_a[3].map(&:inspect)
    puts index.parsed.count
  end


end
