module Varese
  module CensusData
    class VariableMeta < Meta
      attr_reader :guid, :label, :concept, :concept_id, :type

      def initialize(guid, data)
        @guid       = guid
        @label      = data["label"]
        @concept    = data["concept"]
        @concept_id = "#{data["concept"]}".split(".").first
        @type       = derive_type_from_guid(guid)
      end

      private

      def derive_type_from_guid(guid)
        { "E" => :estimate, "M" => :margin_of_error }.fetch("#{guid}".chars.last, :unknown)
      end
    end
  end
end
