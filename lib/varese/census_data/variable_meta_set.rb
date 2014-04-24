module Varese
  module CensusData
    class VariableMetaSet < Meta
      attr_reader :by_guid, :by_label, :by_concept
      def initialize(raw)
        @by_guid    = {}
        @by_label   = Hash.new {|h,k| h[k] = [] }
        @by_concept = Hash.new {|h,k| h[k] = [] }

        raw["variables"].each do |guid, data|
          v = VariableMeta.new(guid, data)
          by_guid[v.guid] = v
          by_label[v.label] << v if v.label
          by_concept[v.concept] << v if v.concept
        end
      end

      # Simple case insensitive matching.
      def search_labels(terms)
        regex = Regexp.new(terms, true)
        by_label.select {|label, _| label.match(regex) }.values.flatten.uniq
      end

      def search_guids(terms)
        by_guid.select {|guid, _| guid[terms] }.values
      end

      def search_concepts(terms)
      end

      def count
        by_guid.count
      end
    end
  end
end
