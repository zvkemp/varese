module Varese
  module CensusData
    class DatasetQueryResponse

      attr_reader :header, :body
      def initialize(header, *body)
        @header, @body = header, body
      end
    end
  end
end
