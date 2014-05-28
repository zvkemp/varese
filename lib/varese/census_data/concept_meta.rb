module Varese
  module CensusData

    # The ConceptMeta class is a wrapper around a collection of related
    # variables. For example, B01001 (sex by age) has 98 associated variables
    # representing every distinct age cohort combined with a binary gender variable.
    # There are also totals on male, female, and an overarching total. In addition,
    # every variable is accompanied by a 'margin of error' counterpart.
    #
    # The constructor is designed to be called from a CensusData::Dataset object's 
    # `concept` method:
    #
    #     dataset.concept("B01001")
    #
    # methods:
    #
    #   attributes: the unique set of attributes described by all of the individual variables
    #     (made by splitting the `!!`-delimited variable description string;
    #     "Margin Of Error For" not included; )
    #   rollup: In order to condense the data into some sort of usable form, the rollup method
    #   is designed to partition and sum data based on the given attributes (variables and geography).
    #   
    #   Of course, it doesn't actually work yet (haven't landed on a suitable api).
    #
    #   Currently, rollups act as downloaders and
    #   automatically download data using the referenced dataset.
    #
    class ConceptMeta < Meta
      attr_reader :variables, :dataset

      def initialize(variables, dataset)
        @variables = variables.sort_by(&:guid)
        @dataset = dataset
      end

      # by size
      def attributes
        variables.map(&:attributes).flatten.uniq
      end

      def rollup(geography)
        Rollup.build(raw_data(geography)) do

        end
      end

      def raw_data(geography)
        DatasetQueryResponse.merge(*guids.each_slice(MAX_VARS_PER_REQUEST).map do |g|
          dataset.query({ get: g.join(",") }.merge(geography))
        end)
      end

      def inspect
        "#<Varese::CensusData::ConceptMeta #{variables.first.concept} (#{variables.count} variables)>"
      end

      private


      def guids
        query_variables.map(&:guid)
      end

      def query_variables
        estimate = variables.select(&:estimate?)
        if estimate.any?
          estimate
        else
          variables
        end
      end
    end

    class Rollup
      class << self
        def build(data, &block)
          new(data, block.call)
        end
      end

      def initialize(data, attrs)
        @data = data
        @attrs = attrs
      end
    end
  end
end
