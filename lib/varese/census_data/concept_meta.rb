module Varese
  module CensusData
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
        data(geography)
      end

      private

      def data(geography)
        DatasetQueryResponse.merge(*guids.each_slice(MAX_VARS_PER_REQUEST).map do |g|
          dataset.query({ get: g.join(",") }.merge(geography))
        end)
      end

      def guids
        query_variables.map(&:guid)
      end

      def query_variables
        variables.select(&:estimate?)
      end
    end
  end
end
