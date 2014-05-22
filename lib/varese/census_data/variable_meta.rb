module Varese
  module CensusData
    class VariableMeta < Meta
      attr_reader :guid, :label, :concept, :concept_id

      def initialize(guid, data)
        @guid       = guid
        @label      = data["label"]
        @concept    = data["concept"]
        @concept_id = "#{data["concept"]}".split(".").first
      end
    end
  end
end
