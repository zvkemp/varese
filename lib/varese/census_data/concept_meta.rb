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
    end
  end
end
