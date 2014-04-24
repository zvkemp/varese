module Varese
  module CensusData
    class VariableMeta < Meta
      attr_reader :guid, :label, :concept

      def initialize(guid, data)
        @guid = guid
        @label = data["label"]
        @concept = data["concept"]
      end
    end
  end
end
