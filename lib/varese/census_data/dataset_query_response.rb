module Varese
  module CensusData
    class DatasetQueryResponse

      attr_reader :header, :body
      def initialize(header, *body)
        @header, @body = header, body
      end

      def to_a
        body.map {|row| Hash[header.zip(row)] }
      end
      
      def rollup(*attributes, options)
        Rollup.new(self, *attributes, options)
      end

    end

    class Rollup
      attr_reader :data, :attributes, :options
      def initialize(data, *attributes, options)
        @data       = data
        @attributes = attributes
        @options    = options
      end
    end
  end
end

__END__


